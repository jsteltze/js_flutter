import 'package:material_ui/material_ui.dart';

enum NumberCardVariant { green }

class NumberCard extends StatefulWidget {
  final String label;
  final String content;
  final bool isExpanded;
  final bool isSelected;
  final Icon? icon;
  final NumberCardVariant? variant;
  final VoidCallback? onSelect;

  const NumberCard(
    this.content, {
    required this.label,
    required this.isExpanded,
    this.isSelected = false,
    this.icon,
    this.variant,
    this.onSelect,
    super.key,
  });

  @override
  State<NumberCard> createState() => _NumberCardState();
}

class _NumberCardState extends State<NumberCard>
    with SingleTickerProviderStateMixin {
  static final animationDuration = Duration(milliseconds: 300);

  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: animationDuration, vsync: this);
    _controller?.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(NumberCard oldWidget) {
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
    Color bgColor = widget.variant == .green
        ? Colors.greenAccent.withAlpha(50)
        : Theme.of(context).colorScheme.surfaceContainerLow
              .withValues(alpha: 0.6);
    Color fontColor = widget.variant == .green
        ? Colors.green.withAlpha(widget.isSelected ? 255 : 180)
        : (widget.isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withAlpha(180));
    if (widget.isSelected) {
      bgColor = Color.alphaBlend(
        bgColor,
        Theme.of(context).colorScheme.primaryContainer,
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: widget.onSelect,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: .all(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: AnimatedSwitcher(
            duration: animationDuration,
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
                      Opacity(
                        opacity: widget.isSelected ? 1.0 : 0.75,
                        child: widget.icon,
                      ),
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.bodySmall!
                            .copyWith(color: fontColor),
                      ),
                      Spacer(),
                      Text(
                        widget.content,
                        style: Theme.of(context).textTheme.headlineLarge!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: fontColor,
                            ),
                      ),
                    ],
                  )
                : Row(
                    key: ValueKey<int>(0),
                    spacing: 5,
                    children: [
                      Opacity(
                        opacity: widget.isSelected ? 1.0 : 0.75,
                        child: widget.icon,
                      ),
                      Text(
                        widget.content,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: fontColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
