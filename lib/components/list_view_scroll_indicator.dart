// Source - https://stackoverflow.com/a/75945137
// Posted by raphaelDev, modified by community. See post 'Timeline' for change history
// Retrieved 2026-10-26, License - CC BY-SA 4.0

import 'package:flutter/material.dart';

class ListViewScrollIndicator extends StatefulWidget {
  const ListViewScrollIndicator({required this.child, super.key});

  final ListView child;

  @override
  State<ListViewScrollIndicator> createState() =>
      _ListViewScrollIndicatorState();
}

class _ListViewScrollIndicatorState extends State<ListViewScrollIndicator> {
  double _stopStart = 0;
  double _stopEnd = 1;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        setState(() {
          _stopStart = scrollNotification.metrics.pixels / 10;
          _stopEnd =
              (scrollNotification.metrics.maxScrollExtent -
                  scrollNotification.metrics.pixels) /
              10;

          _stopStart = _stopStart.clamp(0.0, 1.0);
          _stopEnd = _stopEnd.clamp(0.0, 1.0);
        });
        return true;
      },
      child: Stack(
        alignment: .center,
        children: [
          ShaderMask(
            shaderCallback: (Rect rect) {
              return LinearGradient(
                begin: widget.child.scrollDirection == Axis.horizontal
                    ? Alignment.centerLeft
                    : Alignment.topCenter,
                end: widget.child.scrollDirection == Axis.horizontal
                    ? Alignment.centerRight
                    : Alignment.bottomCenter,
                colors: const [
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black,
                ],
                stops: widget.child.reverse
                    ? [0.0, 0.15 * _stopEnd, 1 - 0.15 * _stopStart, 1.0]
                    : [0.0, 0.15 * _stopStart, 1 - 0.15 * _stopEnd, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: widget.child.scrollDirection == Axis.horizontal
                    ? 10
                    : 0,
              ),
              child: widget.child,
            ),
          ),
          widget.child.scrollDirection == Axis.horizontal
              ? Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Icon(
                      _stopStart > 0 ? Icons.navigate_before : null,
                      color: Theme.of(context).colorScheme.outline
                          .withAlpha(100),
                    ),
                    Icon(
                      _stopEnd > 0 ? Icons.navigate_next : null,
                      color: Theme.of(context).colorScheme.outline
                          .withAlpha(100),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Icon(
                      _stopStart > 0 ? Icons.keyboard_arrow_up : null,
                      color: Theme.of(context).colorScheme.outline
                          .withAlpha(100),
                    ),
                    Icon(
                      _stopEnd > 0 ? Icons.keyboard_arrow_down : null,
                      color: Theme.of(context).colorScheme.outline
                          .withAlpha(100),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
