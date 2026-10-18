import 'package:flutter/material.dart';

class ViewHeader extends StatelessWidget {
  final Widget header;
  final EdgeInsetsGeometry padding;

  const ViewHeader(this.header, {EdgeInsetsGeometry? padding, super.key})
    : padding = padding ?? const EdgeInsets.only(left: 16.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(100),
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
      child: header,
    );
  }
}
