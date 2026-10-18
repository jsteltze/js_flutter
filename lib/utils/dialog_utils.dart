import 'package:flutter/material.dart';
import 'package:js_flutter/utils/snackbar_utils.dart';
import 'package:js_flutter/utils/timestampx.dart';

import '../components/warning.dart';
import '../icons.dart';
import 'export_handler.dart';
import 'logger.dart';

class DialogAction {
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isDestructive;

  DialogAction({
    required this.title,
    this.onPressed,
    this.icon,
    this.isDestructive = false,
  });
}

void openDialog(
  BuildContext context, {
  required String title,
  required Widget Function(
    BuildContext,
    void Function(void Function()),
    void Function(bool x),
  )
  child,
  IconData? titleIcon,
  DialogAction? mainAction,
  List<DialogAction>? secondaryActions,
  String? closeButtonTitle = 'Cancel',
  bool? mainActionEnabled = true,
}) {
  bool mainActionIsEnabled = mainActionEnabled!;
  void toggleMainAction(bool enabled) => mainActionIsEnabled = enabled;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(20),
            icon: Icon(titleIcon),
            title: Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            content: SingleChildScrollView(
              child: child(context, setDialogState, toggleMainAction),
            ),
            actions: <Widget>[
              if (closeButtonTitle != null)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(closeButtonTitle),
                ),
              ...?secondaryActions?.map(
                (a) => TextButton.icon(
                  onPressed: a.onPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: a.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(a.title),
                  icon: Icon(a.icon),
                ),
              ),
              if (mainAction != null)
                ElevatedButton.icon(
                  onPressed: mainActionIsEnabled ? mainAction.onPressed : null,
                  style: TextButton.styleFrom(
                    backgroundColor: mainAction.isDestructive
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primary.withAlpha(
                            mainAction.onPressed == null || !mainActionIsEnabled
                                ? 30
                                : 255,
                          ),
                    foregroundColor: mainAction.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(mainAction.title),
                  icon: mainAction.icon == null ? null : Icon(mainAction.icon),
                ),
            ],
          );
        },
      );
    },
  );
}

void showLogsDialog(BuildContext context) {
  final logs = FileLogger.getLogs();
  openDialog(
    context,
    title: 'Logs',
    titleIcon: Icons.list_alt,
    child: (ctx, setDialogState, toggleMainAction) => Text(
      logs,
      style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
    ),
    closeButtonTitle: null,
    mainAction: DialogAction(
      title: 'Close',
      onPressed: () => Navigator.pop(context),
    ),
    secondaryActions: [
      DialogAction(
        title: 'Export',
        onPressed: () {
          final filename = 'logs-${DateTime.now().toTechString()}.txt';
          ExportHandler.exportToDownloads(
            context,
            filename,
            logs,
            () => Navigator.pop(context),
          );
        },
        icon: exportIcon,
      ),
      DialogAction(
        title: 'Clear',
        onPressed: () {
          FileLogger.clearLogs();
          showSnackbar(context, 'Logs removed');
          Navigator.pop(context);
        },
        isDestructive: true,
        icon: deleteIcon,
      ),
    ],
  );
}

void showErrorDialog(BuildContext context, String msg) {
  openDialog(
    context,
    title: 'Error',
    titleIcon: Icons.error_outline,
    child: (ctx, setDialogState, toggleMainAction) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [const Text('An error occurred:'), Warning(msg)],
    ),
    closeButtonTitle: 'Close',
  );
}

void showWelcomeDialog(
  BuildContext context,
  IconData? titleIcon,
  String message,
) {
  openDialog(
    context,
    title: 'Welcome!',
    titleIcon: titleIcon,
    child: (ctx, setDialogState, toggleMainAction) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Image(image: AssetImage('assets/app_logo.png'), height: 100),
        const SizedBox(height: 20),
        Text(message, textAlign: TextAlign.center),
      ],
    ),
    mainAction: DialogAction(
      title: 'Get Started',
      onPressed: () => Navigator.pop(context),
    ),
    closeButtonTitle: null,
  );
}
