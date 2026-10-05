import 'package:flutter/material.dart';

FloatingActionButton createFAB(
  BuildContext context,
  String tooltip,
  IconData icon,
  Function() onPressed,
) {
  return FloatingActionButton(
    onPressed: onPressed,
    tooltip: tooltip,
    backgroundColor: Theme.of(context).colorScheme.primary,
    child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
  );
}
