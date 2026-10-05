import 'package:flutter/material.dart';
import 'package:js_flutter/utils/dialog_utils.dart';

List<PopupMenuItem<String>> createPopupMenuItems(
  BuildContext context,
  List<DialogAction> items,
) {
  return items
      .map(
        (i) => PopupMenuItem(
          value: i.title,
          enabled: i.onPressed != null,
          child: Row(
            children: [
              if (i.icon != null) ...[
                Icon(
                  i.icon,
                  size: 20,
                  color: i.isDestructive
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
                SizedBox(width: 8),
              ],
              Text(
                i.title,
                style: i.isDestructive
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.error
                            .withAlpha(i.onPressed != null ? 255 : 150),
                      )
                    : null,
              ),
            ],
          ),
        ),
      )
      .toList();
}

PopupMenuButton<String> createPopupMenu(List<DialogAction> items) {
  return PopupMenuButton<String>(
    onSelected: (value) {
      for (var item in items) {
        if (item.title == value) {
          item.onPressed?.call();
          break;
        }
      }
    },
    itemBuilder: (BuildContext context) {
      return createPopupMenuItems(context, items);
    },
    tooltip: 'More options',
  );
}
