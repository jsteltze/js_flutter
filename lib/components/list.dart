import 'package:js_flutter/icons.dart';
import 'package:material_ui/material_ui.dart';

import 'list_view_scroll_indicator.dart';

class MyList<T> extends StatefulWidget {
  final List<T> initialItems;
  final Widget Function(T, Animation<double>) itemBuilder;
  final void Function(T, DismissDirection)? onDismissed;
  final Widget noDataTile;
  final Axis orientation;
  final EdgeInsets? padding;

  const MyList({
    super.key,
    required this.initialItems,
    required this.itemBuilder,
    required this.noDataTile,
    this.orientation = .vertical,
    this.onDismissed,
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
    var id = (x as dynamic).id;
    int editIndex = _currentlyListed.indexWhere((i) => (i as dynamic).id == id);
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
        (ctx, anim) => deletionBackgroundCard(ctx),
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

  Widget deletionBackgroundCard(BuildContext ctx) => Card(
    color: Theme.of(ctx).colorScheme.errorContainer,
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Row(
      spacing: 10,
      children: [
        SizedBox(width: 10),
        Icon(deleteIcon, color: Theme.of(ctx).colorScheme.onErrorContainer),
        Text(
          'DELETE',
          style: TextStyle(color: Theme.of(ctx).colorScheme.onErrorContainer),
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
              itemBuilder: (ctx, index, anim) => widget.onDismissed == null
                  ? widget.itemBuilder.call(_currentlyListed[index], anim)
                  : Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key((_currentlyListed[index] as dynamic).id),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) => widget.onDismissed?.call(
                        _currentlyListed[index],
                        direction,
                      ),
                      direction: .startToEnd,
                      background: deletionBackgroundCard(ctx),
                      child: widget.itemBuilder.call(
                        _currentlyListed[index],
                        anim,
                      ),
                    ),
            ),
          );
  }
}
