import 'package:flutter/material.dart';

enum BadgeVariant { secondary, tertiary, outline, ghost }

class MyBadge extends StatelessWidget {
  final String text;
  final Widget? child;
  final Icon? icon;
  final BadgeVariant variant;
  final Color? background;

  const MyBadge(
    this.text, {
    this.child,
    this.icon,
    this.background,
    BadgeVariant? variant,
    super.key,
  }) : variant = variant ?? .secondary;

  @override
  Widget build(BuildContext context) {
    widget(TextStyle st) => icon == null || icon!.icon == null
        ? Stack(
            alignment: .center,
            children: [
              icon ?? Icon(null, applyTextScaling: true),
              child ?? Text(text, style: st, maxLines: 1, overflow: .ellipsis),
            ],
          )
        : Row(
            spacing: 5,
            mainAxisSize: .min,
            children: [
              ?icon,
              child ??
                  Flexible(
                    child: Text(
                      text,
                      style: st,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ),
            ],
          );

    switch (variant) {
      case .secondary:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color:
                background ??
                Theme.of(context).colorScheme.secondaryContainer
                    .withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: widget(
            Theme.of(context).textTheme.bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        );
      case .tertiary:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color:
                background ??
                Theme.of(context).colorScheme.tertiaryContainer
                    .withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(4),
            border: BoxBorder.all(
              width: 0.5,
              color: Theme.of(context).colorScheme.tertiary.withAlpha(70),
            ),
          ),
          child: widget(
            TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
          ),
        );
      case .outline:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: BoxBorder.all(
              color:
                  background ??
                  Theme.of(context).colorScheme.outline.withAlpha(70),
            ),
          ),
          child: widget(
            Theme.of(context).textTheme.titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        );
      case .ghost:
        return widget(
          Theme.of(context).textTheme.bodySmall!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        );
    }
  }
}
