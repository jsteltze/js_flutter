import 'package:material_ui/material_ui.dart';

class ViewHeader extends StatelessWidget {
  final Widget header;
  final List<Widget>? extension;
  final EdgeInsetsGeometry padding;

  const ViewHeader(
    this.header, {
    EdgeInsetsGeometry? padding,
    this.extension,
    super.key,
  }) : padding =
           padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  @override
  Widget build(BuildContext context) {
    Widget child = extension == null
        ? header
        : ExpansionTile(
            title: header,
            shape: const Border(),
            children: extension!,
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
      child: child,
    );
  }
}
