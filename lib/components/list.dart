import 'package:flutter/material.dart';

import 'list_view_scroll_indicator.dart';

class MyList {
  static Widget of({
    Axis orientation = .vertical,
    double? fixedHeight,
    required List<Widget> items,
  }) {
    ScrollController controller = ScrollController();
    final child = ListViewScrollIndicator(
      controller: controller,
      scrollDirection: orientation,
      child: ListView(
        scrollDirection: orientation,
        controller: controller,
        children: items,
      ),
    );
    if (fixedHeight != null) {
      return SizedBox(height: fixedHeight, child: child);
    } else {
      return child;
    }
  }

  static Widget animated({
    required Key listKey,
    required int initialItemCount,
    required Widget Function(BuildContext, int, Animation<double>) itemBuilder,
    Axis orientation = .vertical,
    EdgeInsets padding = const EdgeInsets.only(bottom: 100),
  }) {
    ScrollController controller = ScrollController();
    return ListViewScrollIndicator(
      controller: controller,
      scrollDirection: orientation,
      child: AnimatedList(
        key: listKey,
        controller: controller,
        padding: padding,
        initialItemCount: initialItemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
