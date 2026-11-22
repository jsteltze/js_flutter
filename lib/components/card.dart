import 'package:material_ui/material_ui.dart';

enum BadgeVariant { primary, secondary, tertiary, outline, ghost }

class MyCard extends StatelessWidget {
  final Widget child;
  final bool isDestructive;
  final bool isHighlighted;

  const MyCard({
    super.key,
    required this.child,
    this.isDestructive = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    color: Colors.transparent,
    child: Card(
      color: isDestructive
          ? Theme.of(ctx).colorScheme.errorContainer
          : Theme.of(ctx).colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHighlighted
            ? BorderSide(
                color: isDestructive
                    ? Theme.of(ctx).colorScheme.error
                    : Theme.of(ctx).colorScheme.primary,
                width: 2,
              )
            : BorderSide(
                color: isDestructive
                    ? Theme.of(ctx).colorScheme.error
                    : Theme.of(ctx).colorScheme.outline,
                width: 0.5,
              ),
      ),
      child: child,
    ),
  );
}
