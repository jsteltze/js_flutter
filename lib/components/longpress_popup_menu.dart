import 'package:flutter/material.dart';
import 'package:js_flutter/components/popup_menu.dart';
import 'package:js_flutter/utils/dialog_utils.dart';

/// A simple long press popup menu.
class LongPressPopupMenu extends StatefulWidget {
  /// The popup menu entries for the long press menu.
  final List<DialogAction> items;

  /// The child that can be long pressed to activate the long press menu.
  final Widget child;

  /// Default constructor
  const LongPressPopupMenu({
    super.key,
    required this.child,
    required this.items,
  });

  @override
  State<StatefulWidget> createState() => _LongPressPopupMenuState();
}

class _LongPressPopupMenuState extends State<LongPressPopupMenu> {
  Offset _downPosition = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .translucent,
      onTapDown: (TapDownDetails details) {
        _downPosition = details.globalPosition;
      },
      onLongPress: () async {
        final RenderBox? overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox?;
        if (overlay != null) {
          final String? value = await showMenu<String>(
            context: context,
            items: createPopupMenuItems(context, widget.items),
            position: RelativeRect.fromLTRB(
              _downPosition.dx,
              _downPosition.dy,
              overlay.size.width - _downPosition.dx,
              overlay.size.height - _downPosition.dy,
            ),
          );
          if (value != null) {
            for (var item in widget.items) {
              if (item.title == value) {
                item.onPressed?.call();
                break;
              }
            }
          }
        }
      },
      child: widget.child,
    );
  }
}
