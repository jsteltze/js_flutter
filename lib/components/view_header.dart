import 'package:material_ui/material_ui.dart';

class ViewHeader extends StatelessWidget {
  final List<Widget>? headerWidgets;
  final String headerTitle;
  final Icon? headerIcon;
  final List<Widget>? extensionWidgets;
  final List<Widget>? otherWidgets;
  final EdgeInsetsGeometry? padding;
  final void Function(bool value)? onExpansionChanged;

  const ViewHeader({
    required this.headerTitle,
    this.headerWidgets,
    this.headerIcon,
    this.padding,
    this.extensionWidgets,
    this.otherWidgets,
    this.onExpansionChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = ExpansionTile(
      title: Row(
        spacing: 10,
        children: [
          ?headerIcon,
          Container(
            padding: .only(top: 3),
            child: Text(
              headerTitle,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: .normal,
              ),
            ),
          ),
          ...?headerWidgets,
        ],
      ),
      onExpansionChanged: onExpansionChanged,
      shape: const Border(),
      children: extensionWidgets == null
          ? []
          : [Divider(), ...?extensionWidgets],
    );

    return Ink(
      width: .infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: BoxBorder.symmetric(
          horizontal: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        borderRadius: .vertical(bottom: .circular(20)),
      ),
      child: otherWidgets == null
          ? child
          : Column(children: [child, ...?otherWidgets]),
    );
  }
}
