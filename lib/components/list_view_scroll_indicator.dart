// Source - https://stackoverflow.com/a/75945137
// Posted by raphaelDev, modified by community. See post 'Timeline' for change history
// Retrieved 2026-10-26, License - CC BY-SA 4.0

import 'package:material_ui/material_ui.dart';

class ListViewScrollIndicator extends StatefulWidget {
  const ListViewScrollIndicator({
    required this.child,
    this.scrollDirection = .vertical,
    this.controller,
    super.key,
  });

  final ScrollController? controller;
  final Axis scrollDirection;
  final Widget child;

  @override
  State<ListViewScrollIndicator> createState() =>
      _ListViewScrollIndicatorState();
}

class _ListViewScrollIndicatorState extends State<ListViewScrollIndicator> {
  double _stopStart = 0;
  double _stopEnd = 1;
  bool _showNextIcon = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double? maxScroll2 = widget.controller?.position.maxScrollExtent;
      if (maxScroll2 != null && maxScroll2 > 0 && !_showNextIcon) {
        setState(() {
          _showNextIcon = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.scrollDirection == .horizontal ? 0.15 : 0.05;
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
          _showNextIcon = _stopEnd == 1;
        });
        return true;
      },
      child: Stack(
        alignment: .center,
        children: [
          ShaderMask(
            shaderCallback: (Rect rect) {
              return LinearGradient(
                begin: widget.scrollDirection == .horizontal
                    ? Alignment.centerLeft
                    : Alignment.topCenter,
                end: widget.scrollDirection == .horizontal
                    ? Alignment.centerRight
                    : Alignment.bottomCenter,
                colors: const [
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black,
                ],
                stops: [0.0, ratio * _stopStart, 1 - ratio * _stopEnd, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: widget.scrollDirection == .horizontal ? 10 : 0,
              ),
              child: widget.child,
            ),
          ),
          widget.scrollDirection == .horizontal
              ? Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Icon(
                      _stopStart > 0 ? Icons.navigate_before : null,
                      color: Theme.of(context).colorScheme.outline
                          .withAlpha(100),
                    ),
                    Icon(
                      _showNextIcon ? Icons.navigate_next : null,
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
                      _showNextIcon ? Icons.keyboard_arrow_down : null,
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
