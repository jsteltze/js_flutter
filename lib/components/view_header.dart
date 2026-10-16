import 'package:flutter/material.dart';

class ViewHeader extends StatelessWidget {
  final Widget header;

  const ViewHeader(this.header, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.all(16.0),
      child: header,
    );
  }
}
