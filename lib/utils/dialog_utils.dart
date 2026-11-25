import 'package:js_flutter/utils/datetimex.dart';
import 'package:js_flutter/utils/snackbar_utils.dart';
import 'package:material_ui/material_ui.dart';

import '../components/warning.dart';
import '../icons.dart';
import 'export_handler.dart';
import 'logger.dart';

/// 400 seems to be a good width for formular dialogs.
/// Using the maximum device width can result in ridiculously large dialogs
/// especially on big screens in landscape mode. That's why a fixed
/// width seems reasonable. Flutter automatically downsizes if the device
/// width is not sufficient.
final double defaultFormularDialogWidth = 400.0;

class DialogAction {
  final String title;
  final Function(void Function(void Function())?)? onPressed;
  final IconData? icon;
  final bool isDestructive;

  DialogAction({
    required this.title,
    this.onPressed,
    this.icon,
    this.isDestructive = false,
  });
}

Future<int> openDialog(
  BuildContext context, {
  String? title,
  required Widget Function(
    BuildContext,
    void Function(void Function()),
    void Function(bool x),
  )
  child,
  double? width,
  IconData? titleIcon,
  DialogAction? mainAction,
  List<DialogAction>? secondaryActions,
  String? closeButtonTitle = 'Cancel',
  bool? mainActionEnabled = true,
}) async {
  bool mainActionIsEnabled = mainActionEnabled!;
  void toggleMainAction(bool enabled) => mainActionIsEnabled = enabled;

  int? result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          insetPadding: EdgeInsets.all(20),
          icon: Icon(titleIcon),
          title: title != null
              ? Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
          content: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: child(context, setDialogState, toggleMainAction),
            ),
          ),
          actions: <Widget>[
            if (closeButtonTitle != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(0),
                child: Text(closeButtonTitle),
              ),
            ...?secondaryActions?.map(
              (a) => TextButton.icon(
                onPressed: () => a.onPressed?.call(setDialogState),
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
                onPressed: mainActionIsEnabled
                    ? () {
                        Navigator.of(context).pop(1);
                        mainAction.onPressed?.call(setDialogState);
                      }
                    : null,
                style: TextButton.styleFrom(
                  backgroundColor: mainAction.isDestructive
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.primary
                            .withAlpha(!mainActionIsEnabled ? 30 : 255),
                  foregroundColor: mainAction.isDestructive
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(mainAction.title),
                icon: mainAction.icon == null ? null : Icon(mainAction.icon),
              ),
          ],
        ),
      );
    },
  );
  return result ?? 0;
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
    mainAction: DialogAction(title: 'Close'),
    secondaryActions: [
      DialogAction(
        title: 'Export',
        onPressed: (_) {
          final filename = 'logs-${DateTime.now().toTechString()}.txt';
          ExportHandler.exportToDownloads(context, filename, logs);
        },
        icon: exportIcon,
      ),
      DialogAction(
        title: 'Clear',
        onPressed: (_) {
          FileLogger.clearLogs();
          showSnackbar(context, 'Logs removed');
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
      mainAxisSize: .min,
      children: [const Text('An error occurred:'), Warning(msg)],
    ),
    closeButtonTitle: 'Close',
  );
}

void showWelcomeDialog(
  BuildContext context,
  String message, {
  IconData? titleIcon,
}) {
  openDialog(
    context,
    title: 'Welcome!',
    titleIcon: titleIcon,
    child: (ctx, setDialogState, toggleMainAction) => Column(
      mainAxisSize: .min,
      children: [
        const Image(image: AssetImage('assets/app_logo.png'), height: 100),
        const SizedBox(height: 20),
        Text(message, textAlign: .center),
      ],
    ),
    mainAction: DialogAction(title: 'Get Started'),
    closeButtonTitle: null,
  );
}
