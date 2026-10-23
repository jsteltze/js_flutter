import 'package:flutter/material.dart';

enum NumberCardVariant { green }

class NumberCard2 extends StatefulWidget {
  final String label;
  final String content;
  final bool isExpanded;
  final Icon? icon;
  final NumberCardVariant? variant;

  const NumberCard2(
    this.content, {
    required this.label,
    required this.isExpanded,
    this.icon,
    this.variant,
    super.key,
  });

  @override
  State<NumberCard2> createState() => _NumberCardState();
}

class _NumberCardState extends State<NumberCard2>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller?.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(NumberCard2 oldWidget) {
    _controller?.reset();
    _controller?.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: widget.variant == .green
              ? Colors.greenAccent.withAlpha(50)
              : Theme.of(context).colorScheme.secondaryContainer
                    .withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                alignment: .topLeft,
                child: child,
              ),
            );
          },
          child: widget.isExpanded
              ? Column(
                  key: ValueKey<int>(1),
                  spacing: 5,
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  mainAxisSize: .max,
                  children: [
                    ?widget.icon,
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: widget.variant == .green
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.content,
                      style: Theme.of(context).textTheme.headlineLarge!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.variant == .green
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                )
              : Row(
                  key: ValueKey<int>(0),
                  spacing: 5,
                  children: [
                    ?widget.icon,
                    Text(
                      widget.content,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.variant == .green
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
