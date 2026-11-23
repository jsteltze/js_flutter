import 'package:js_flutter/components/card.dart';
import 'package:js_flutter/utils/dialog_utils.dart';
import 'package:material_ui/material_ui.dart';

import 'list_view_scroll_indicator.dart';

class DismissAction<T> extends DialogAction {
  final void Function(T) onDismissed;
  final Future<bool?> Function(T)? confirmDismiss;

  new({
    required super.title,
    super.isDestructive,
    super.icon,
    required this.onDismissed,
    this.confirmDismiss,
  });
}

class MyList<T> extends StatefulWidget {
  final List<T> initialItems;
  final Widget Function(T, Animation<double>) itemBuilder;
  final DismissAction<T>? onDismissedPrimary;
  final DismissAction<T>? onDismissedSecondary;
  final Widget noDataTile;
  final Axis orientation;
  final EdgeInsets? padding;

  const MyList({
    super.key,
    required this.initialItems,
    required this.itemBuilder,
    required this.noDataTile,
    this.orientation = .vertical,
    this.onDismissedPrimary,
    this.onDismissedSecondary,
    this.padding,
  });

  @override
  State<MyList> createState() => MyListState<T>();

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
}

class MyListState<T> extends State<MyList<T>> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<T> _currentlyListed = [];
  bool _showNoDataView = false;

  void doFiltering(List<T> filtered) {
    if (listKey.currentState != null) {
      // remove due to filter
      for (int i = 0; i < _currentlyListed.length; i++) {
        if (!filtered.contains(_currentlyListed[i])) {
          T item = _currentlyListed[i];
          listKey.currentState?.removeItem(
            i,
            (_, anim) => widget.itemBuilder.call(item, anim),
          );
          _currentlyListed.removeAt(i--);
        }
      }

      // add due to filter
      for (int i = 0; i < filtered.length; i++) {
        if (!_currentlyListed.contains(filtered[i])) {
          listKey.currentState?.insertItem(i);
        }
      }

      setState(() {
        _currentlyListed = filtered.toList();
      });

      if (_currentlyListed.isEmpty) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _showNoDataView = true;
            });
          }
        });
      }
    } else {
      // listKey.currentState is null so there was currently no
      // list displayed -> re-call _doFiltering
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showNoDataView = false;
            doFiltering(filtered);
          });
        }
      });
    }
  }

  void insert(T x) {
    listKey.currentState?.insertItem(0);
    _currentlyListed.insert(0, x);
  }

  void edit(T x) {
    var id = (x as dynamic).id.toString();
    int editIndex = _currentlyListed.indexWhere(
      (i) => (i as dynamic).id.toString() == id,
    );
    if (mounted) {
      setState(() {
        _currentlyListed[editIndex] = x;
      });
    }
  }

  void remove(T x, {DismissDirection? dismiss}) {
    if (dismiss == null) {
      listKey.currentState?.removeItem(
        _currentlyListed.indexOf(x),
        (ctx, anim) => widget.itemBuilder.call(x, anim),
      );
    } else {
      listKey.currentState?.removeItem(
        _currentlyListed.indexOf(x),
        (ctx, anim) => dismiss == .startToEnd
            ? dismissBackgroundCard(ctx, widget.onDismissedPrimary!)
            : dismissBackgroundCard(ctx, widget.onDismissedSecondary!),
        // avoid duplicate animation when item was removed by dismiss gesture
        duration: Duration(seconds: 0),
      );
    }

    setState(() {
      _currentlyListed.remove(x);
    });

    if (_currentlyListed.isEmpty) {
      // show NoDataTile when filter result is empty
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showNoDataView = true;
          });
        }
      });
    }
  }

  Widget dismissBackgroundCard(BuildContext ctx, DialogAction action) => MyCard(
    isDestructive: action.isDestructive,
    child: Row(
      spacing: 10,
      children: [
        SizedBox(width: 10),
        Icon(
          action.icon,
          color: action.isDestructive
              ? Theme.of(ctx).colorScheme.onErrorContainer
              : Theme.of(ctx).colorScheme.onSecondaryContainer,
        ),
        Text(
          action.title.toUpperCase(),
          style: TextStyle(
            color: action.isDestructive
                ? Theme.of(ctx).colorScheme.onErrorContainer
                : Theme.of(ctx).colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentlyListed = widget.initialItems.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // apply default bottom padding for floating action buttons
    EdgeInsets pad =
        widget.padding ??
        EdgeInsets.only(bottom: MediaQuery.of(context).textScaler.scale(100));

    ScrollController controller = ScrollController();
    return _currentlyListed.isEmpty && _showNoDataView
        ? widget.noDataTile
        : ListViewScrollIndicator(
            controller: controller,
            scrollDirection: widget.orientation,
            child: AnimatedList(
              key: listKey,
              controller: controller,
              padding: pad,
              initialItemCount: _showNoDataView || _currentlyListed.isEmpty
                  ? 0
                  : widget.initialItems.length,
              itemBuilder: (ctx, index, anim) =>
                  widget.onDismissedPrimary == null &&
                      widget.onDismissedSecondary == null
                  ? widget.itemBuilder.call(_currentlyListed[index], anim)
                  : Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(
                        (_currentlyListed[index] as dynamic).id.toString(),
                      ),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) => direction == .startToEnd
                          ? widget.onDismissedPrimary?.onDismissed.call(
                              _currentlyListed[index],
                            )
                          : widget.onDismissedSecondary?.onDismissed.call(
                              _currentlyListed[index],
                            ),
                      confirmDismiss: (direction) async {
                        if (direction == .startToEnd) {
                          return widget.onDismissedPrimary!.confirmDismiss ==
                                  null
                              ? true
                              : widget.onDismissedPrimary!.confirmDismiss!.call(
                                  _currentlyListed[index],
                                );
                        } else {
                          return widget.onDismissedSecondary!.confirmDismiss ==
                                  null
                              ? true
                              : widget.onDismissedSecondary!.confirmDismiss!
                                    .call(_currentlyListed[index]);
                        }
                      },
                      direction: widget.onDismissedPrimary == null
                          ? .endToStart
                          : widget.onDismissedSecondary == null
                          ? .startToEnd
                          : .horizontal,
                      background: widget.onDismissedPrimary == null
                          ? null
                          : dismissBackgroundCard(
                              ctx,
                              widget.onDismissedPrimary!,
                            ),
                      secondaryBackground: widget.onDismissedSecondary == null
                          ? null
                          : dismissBackgroundCard(
                              ctx,
                              widget.onDismissedSecondary!,
                            ),

                      child: widget.itemBuilder.call(
                        _currentlyListed[index],
                        anim,
                      ),
                    ),
            ),
          );
  }
}
