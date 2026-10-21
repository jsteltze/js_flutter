import 'package:flutter/material.dart';

enum NumberCardVariant { green }

class NumberCard extends StatelessWidget {
  final String label;
  final String content;
  final Icon? icon;
  final NumberCardVariant? variant;

  const NumberCard(
    this.content, {
    required this.label,
    this.icon,
    this.variant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: variant == .green
              ? Colors.greenAccent.withAlpha(50)
              : Theme.of(context).colorScheme.secondaryContainer
                    .withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          spacing: 5,
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          mainAxisSize: .max,
          children: [
            ?icon,
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall!
                  .copyWith(color: variant == .green ? Colors.green : null),
            ),
            Spacer(),
            Text(
              content,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: variant == .green ? Colors.green : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
