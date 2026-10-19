import 'package:flutter/material.dart';

class ViewHeader extends StatelessWidget {
  final Widget header;
  final EdgeInsetsGeometry padding;

  const ViewHeader(this.header, {EdgeInsetsGeometry? padding, super.key})
    : padding =
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
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
