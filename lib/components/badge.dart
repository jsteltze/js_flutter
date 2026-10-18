import 'package:flutter/material.dart';

enum BadgeVariant { secondary, tertiary }

class MyBadge extends StatelessWidget {
  final String text;
  final Widget? child;
  final Icon? icon;
  final BadgeVariant variant;

  const MyBadge(
    this.text, {
    this.child,
    this.icon,
    BadgeVariant? variant,
    super.key,
  }) : variant = variant ?? BadgeVariant.secondary;

  @override
  Widget build(BuildContext context) {
    TextStyle style = variant == BadgeVariant.secondary
        ? Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          )
        : TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer);
    Widget widget = icon == null
        ? Stack(
            alignment: Alignment.center,
            children: [
              Icon(null, applyTextScaling: true),
              child ?? Text(text, style: style),
            ],
          )
        : Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              ?icon,
              child ?? Text(text, style: style),
            ],
          );

    return variant == BadgeVariant.secondary
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer
                  .withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: widget,
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer
                  .withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: widget,
          );
  }
}
