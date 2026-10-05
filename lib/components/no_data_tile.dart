import 'package:flutter/material.dart';
import 'package:js_flutter/utils/dialog_utils.dart';

class NoDataTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final DialogAction? actionButton;

  const NoDataTile({
    super.key,
    required this.text,
    required this.icon,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withAlpha(100),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          if (actionButton != null)
            TextButton(
              onPressed: actionButton!.onPressed,
              child: Text(actionButton!.title),
            ),
        ],
      ),
    );
  }
}
