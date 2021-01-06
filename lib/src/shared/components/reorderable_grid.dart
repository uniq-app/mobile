library reorderableitemsview;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

typedef ReorderCallback = void Function(int oldIndex, int newIndex);

typedef IndexedFeedBackWidgetBuilder = Widget Function(
    BuildContext context, int index, Widget child);

class ReorderableItemsView extends StatefulWidget {
  ReorderableItemsView({
    Key key,
    this.header,
    @required this.children,
    @required this.onReorder,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.staggeredTiles,
    this.crossAxisCount = 3,
    this.isGrid = false,
    this.reverse = false,
    this.longPressToDrag = true,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.feedBackWidgetBuilder,
  })  : assert(scrollDirection != null),
        assert(onReorder != null),
        assert(children != null),
        assert(
          children.every((Widget w) => w.key != null),
          'All children of this widget must have a key.',
        ),
        super(key: key);

  final Widget header;

  final List<Widget> children;

  final Axis scrollDirection;

  final ScrollController scrollController;

  final EdgeInsets padding;

  final bool reverse;

  final ReorderCallback onReorder;

  final List<StaggeredTile> staggeredTiles;

  final int crossAxisCount;

  final bool isGrid;

  final bool longPressToDrag;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final IndexedFeedBackWidgetBuilder feedBackWidgetBuilder;

  @override
  _ReorderableItemsViewState createState() => _ReorderableItemsViewState();
}

class _ReorderableItemsViewState extends State<ReorderableItemsView> {
  final GlobalKey _overlayKey =
      GlobalKey(debugLabel: '$ReorderableItemsView overlay key');

  OverlayEntry _listOverlayEntry;

  @override
  void initState() {
    super.initState();
    _listOverlayEntry = OverlayEntry(
      opaque: true,
      builder: (BuildContext context) {
        return _ReorderableListContent(
          header: widget.header,
          children: widget.children,
          scrollController: widget.scrollController,
          scrollDirection: widget.scrollDirection,
          onReorder: widget.onReorder,
          padding: widget.padding,
          reverse: widget.reverse,
          staggeredTiles: widget.staggeredTiles,
          crossAxisCount: widget.crossAxisCount,
          isGrid: widget.isGrid,
          longPressToDrag: widget.longPressToDrag,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
          feedBackWidgetBuilder: widget.feedBackWidgetBuilder,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(key: _overlayKey, initialEntries: <OverlayEntry>[
      _listOverlayEntry,
    ]);
  }
}

class _ReorderableListContent extends StatefulWidget {
  const _ReorderableListContent({
    @required this.header,
    @required this.children,
    @required this.scrollController,
    @required this.scrollDirection,
    @required this.padding,
    @required this.onReorder,
    @required this.reverse,
    @required this.staggeredTiles,
    @required this.crossAxisCount,
    @required this.isGrid,
    @required this.longPressToDrag,
    @required this.mainAxisSpacing,
    @required this.crossAxisSpacing,
    @required this.feedBackWidgetBuilder,
  });

  final Widget header;
  final List<Widget> children;
  final ScrollController scrollController;
  final Axis scrollDirection;
  final EdgeInsets padding;
  final ReorderCallback onReorder;
  final bool reverse;
  final List<StaggeredTile> staggeredTiles;
  final int crossAxisCount;
  final bool isGrid;
  final bool longPressToDrag;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final IndexedFeedBackWidgetBuilder feedBackWidgetBuilder;

  @override
  _ReorderableListContentState createState() => _ReorderableListContentState();
}

class _ReorderableListContentState extends State<_ReorderableListContent>
    with TickerProviderStateMixin<_ReorderableListContent> {
  static const double _defaultDropAreaExtent = 100.0;

  static const double _dropAreaMargin = 8.0;

  static const Duration _reorderAnimationDuration = Duration(milliseconds: 200);

  static const Duration _scrollAnimationDuration = Duration(milliseconds: 200);

  ScrollController _scrollController;

  AnimationController _entranceController;

  AnimationController _ghostController;

  Key _dragging;

  Size _draggingFeedbackSize;

  int _dragStartIndex = 0;

  int _ghostIndex = 0;

  int _currentIndex = 0;

  int _nextIndex = 0;

  bool _scrolling = false;

  double get _dropAreaExtent {
    if (_draggingFeedbackSize == null) {
      return _defaultDropAreaExtent;
    }
    double dropAreaWithoutMargin;
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        dropAreaWithoutMargin = _draggingFeedbackSize.width;
        break;
      case Axis.vertical:
      default:
        dropAreaWithoutMargin = _draggingFeedbackSize.height;
        break;
    }
    return dropAreaWithoutMargin + _dropAreaMargin;
  }

  @override
  void initState() {
    super.initState();
    _entranceController =
        AnimationController(vsync: this, duration: _reorderAnimationDuration);
    _ghostController =
        AnimationController(vsync: this, duration: _reorderAnimationDuration);
    _entranceController.addStatusListener(_onEntranceStatusChanged);
  }

  @override
  void didChangeDependencies() {
    _scrollController = widget.scrollController ??
        PrimaryScrollController.of(context) ??
        ScrollController();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ghostController.dispose();
    super.dispose();
  }

  void _requestAnimationToNextIndex() {
    if (_entranceController.isCompleted) {
      _ghostIndex = _currentIndex;
      if (_nextIndex == _currentIndex) {
        return;
      }
      _currentIndex = _nextIndex;
      _ghostController.reverse(from: 1.0);
      _entranceController.forward(from: 0.0);
    }
  }

  void _onEntranceStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _requestAnimationToNextIndex();
      });
    }
  }

  void _scrollTo(BuildContext context) {
    if (_scrolling) return;
    final RenderObject contextObject = context.findRenderObject();
    final RenderAbstractViewport viewport =
        RenderAbstractViewport.of(contextObject);
    assert(viewport != null);

    final double margin = _dropAreaExtent;
    final double scrollOffset = _scrollController.offset;
    final double topOffset = max(
      _scrollController.position.minScrollExtent,
      viewport.getOffsetToReveal(contextObject, 0.0).offset - margin,
    );
    final double bottomOffset = min(
      _scrollController.position.maxScrollExtent,
      viewport.getOffsetToReveal(contextObject, 1.0).offset + margin,
    );
    final bool onScreen =
        scrollOffset <= topOffset && scrollOffset >= bottomOffset;

    if (!onScreen) {
      _scrolling = true;
      _scrollController.position
          .animateTo(
        scrollOffset < bottomOffset ? bottomOffset : topOffset,
        duration: _scrollAnimationDuration,
        curve: Curves.easeInOut,
      )
          .then((void value) {
        setState(() {
          _scrolling = false;
        });
      });
    }
  }

  Widget _buildContainerForScrollDirection({List<Widget> children}) {
    if (widget.isGrid) {
      assert(widget.staggeredTiles != null);
    }

    if (widget.isGrid)
      return StaggeredGridView.count(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: widget.crossAxisCount,
        staggeredTiles: widget.staggeredTiles,
        children: children,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
      );
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        return Row(children: children);
      case Axis.vertical:
      default:
        return Column(children: children);
    }
  }

  Widget _wrap(Widget toWrap, int index, BoxConstraints constraints) {
    assert(toWrap.key != null);
    final GlobalObjectKey keyIndexGlobalKey = GlobalObjectKey(toWrap.key);

    void onDragStarted() {
      setState(() {
        _dragging = toWrap.key;
        _dragStartIndex = index;
        _ghostIndex = index;
        _currentIndex = index;
        _entranceController.value = 1.0;
        _draggingFeedbackSize = keyIndexGlobalKey.currentContext.size;
      });
    }

    void reorder(int startIndex, int endIndex) {
      setState(() {
        if (startIndex != endIndex && endIndex < widget.children.length)
          widget.onReorder(startIndex, endIndex);
        _ghostController.reverse(from: 0.1);
        _entranceController.reverse(from: 0.1);
        _dragging = null;
      });
    }

    void onDragEnded() {
      reorder(_dragStartIndex, _currentIndex);
    }

    Widget wrapWithSemantics() {
      final Map<CustomSemanticsAction, VoidCallback> semanticsActions =
          <CustomSemanticsAction, VoidCallback>{};

      void moveToStart() => reorder(index, 0);
      void moveToEnd() => reorder(index, widget.children.length);
      void moveBefore() => reorder(index, index - 1);

      void moveAfter() => reorder(index, index + 2);

      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);

      if (index > 0) {
        semanticsActions[CustomSemanticsAction(
            label: localizations.reorderItemToStart)] = moveToStart;
        String reorderItemBefore = localizations.reorderItemUp;
        if (widget.scrollDirection == Axis.horizontal) {
          reorderItemBefore = Directionality.of(context) == TextDirection.ltr
              ? localizations.reorderItemLeft
              : localizations.reorderItemRight;
        }
        semanticsActions[CustomSemanticsAction(label: reorderItemBefore)] =
            moveBefore;
      }

      if (index < widget.children.length - 1) {
        String reorderItemAfter = localizations.reorderItemDown;
        if (widget.scrollDirection == Axis.horizontal) {
          reorderItemAfter = Directionality.of(context) == TextDirection.ltr
              ? localizations.reorderItemRight
              : localizations.reorderItemLeft;
        }
        semanticsActions[CustomSemanticsAction(label: reorderItemAfter)] =
            moveAfter;
        semanticsActions[
                CustomSemanticsAction(label: localizations.reorderItemToEnd)] =
            moveToEnd;
      }

      return KeyedSubtree(
        key: keyIndexGlobalKey,
        child: MergeSemantics(
          child: Semantics(
            customSemanticsActions: semanticsActions,
            child: toWrap,
          ),
        ),
      );
    }

    Widget buildDragTarget(BuildContext context, List<Key> acceptedCandidates,
        List<dynamic> rejectedCandidates) {
      final Widget toWrapWithSemantics = wrapWithSemantics();

      double mainAxisExtent = 0.0;
      double crossAxisExtent = 0.0;

      BoxConstraints newConstraints = constraints;

      if (widget.isGrid &&
          _dragging == null &&
          index < widget.staggeredTiles.length) {
        final StaggeredTile tile = widget.staggeredTiles[index];

        final double usableCrossAxisExtent = constraints.biggest.width;
        final double cellExtent = usableCrossAxisExtent / widget.crossAxisCount;

        mainAxisExtent = constraints.biggest.height;

        crossAxisExtent = cellExtent * tile.crossAxisCellCount;

        newConstraints = constraints.copyWith(
          minWidth: crossAxisExtent,
          maxWidth: crossAxisExtent,
          minHeight: mainAxisExtent,
          maxHeight: mainAxisExtent,
        );
      } else {
        newConstraints = constraints.copyWith(
          minWidth: 0.0,
          maxWidth: constraints.maxWidth,
          minHeight: 0.0,
          maxHeight: constraints.maxHeight,
        );
      }

      Widget child = widget.longPressToDrag
          ? LongPressDraggable<Key>(
              maxSimultaneousDrags: 1,
              axis: null,
              data: toWrap.key,
              ignoringFeedbackSemantics: false,
              feedback: widget.feedBackWidgetBuilder != null
                  ? widget.feedBackWidgetBuilder(
                      context, index, toWrapWithSemantics)
                  : Container(
                      alignment: Alignment.topLeft,
                      constraints: newConstraints,
                      child: Material(
                        elevation: 6.0,
                        child: toWrapWithSemantics,
                      ),
                    ),
              child: _dragging == toWrap.key
                  ? const SizedBox()
                  : toWrapWithSemantics,
              childWhenDragging: const SizedBox(),
              dragAnchor: DragAnchor.child,
              onDragStarted: onDragStarted,
              onDragCompleted: onDragEnded,
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                onDragEnded();
              },
            )
          : Draggable<Key>(
              maxSimultaneousDrags: 1,
              axis: null,
              data: toWrap.key,
              ignoringFeedbackSemantics: false,
              feedback: widget.feedBackWidgetBuilder != null
                  ? widget.feedBackWidgetBuilder(
                      context, index, toWrapWithSemantics)
                  : Container(
                      alignment: Alignment.topLeft,
                      constraints: newConstraints,
                      child: Material(
                        elevation: 6.0,
                        child: toWrapWithSemantics,
                      ),
                    ),
              child: _dragging == toWrap.key
                  ? const SizedBox()
                  : toWrapWithSemantics,
              childWhenDragging: const SizedBox(),
              dragAnchor: DragAnchor.child,
              onDragStarted: onDragStarted,
              onDragCompleted: onDragEnded,
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                onDragEnded();
              },
            );

      if (index >= widget.children.length) {
        child = toWrap;
      }

      Widget spacing;
      switch (widget.scrollDirection) {
        case Axis.horizontal:
          spacing = SizedBox(width: _dropAreaExtent);
          break;
        case Axis.vertical:
        default:
          spacing = SizedBox(height: _dropAreaExtent);
          break;
      }

      if (_currentIndex == index && _dragging != null && !widget.isGrid) {
        return _buildContainerForScrollDirection(children: <Widget>[
          SizeTransition(
            sizeFactor: _entranceController,
            axis: widget.scrollDirection,
            child: spacing,
          ),
          child,
        ]);
      }

      if (_ghostIndex == index && _dragging != null && !widget.isGrid) {
        return _buildContainerForScrollDirection(children: <Widget>[
          SizeTransition(
            sizeFactor: _ghostController,
            axis: widget.scrollDirection,
            child: spacing,
          ),
          child,
        ]);
      }

      if (_ghostIndex == index && _dragging != null && widget.isGrid) {
        return Opacity(
          opacity: .5,
          child: child,
        );
      }
      return child;
    }

    return Builder(builder: (BuildContext context) {
      return DragTarget<Key>(
        builder: buildDragTarget,
        onWillAccept: (Key toAccept) {
          setState(() {
            _nextIndex = index;
            _requestAnimationToNextIndex();
          });
          _scrollTo(context);

          return _dragging == toAccept && toAccept != toWrap.key;
        },
        onAccept: (Key accepted) {},
        onLeave: (Object leaving) {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      const Key endWidgetKey = Key('DraggableList - End Widget');
      Widget finalDropArea;
      switch (widget.scrollDirection) {
        case Axis.horizontal:
          finalDropArea = SizedBox(
            key: endWidgetKey,
            width: _defaultDropAreaExtent,
            height: constraints.maxHeight,
          );
          break;
        case Axis.vertical:
        default:
          finalDropArea = SizedBox(
            key: endWidgetKey,
            height: _defaultDropAreaExtent,
            width: constraints.maxWidth,
          );
          break;
      }
      return SingleChildScrollView(
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        controller: _scrollController,
        reverse: widget.reverse,
        child: _buildContainerForScrollDirection(
          children: <Widget>[
            if (widget.reverse)
              _wrap(finalDropArea, widget.children.length, constraints),
            if (widget.header != null) widget.header,
            for (int i = 0; i < widget.children.length; i += 1)
              _wrap(widget.children[i], i, constraints),
            if (!widget.reverse)
              _wrap(finalDropArea, widget.children.length, constraints),
          ],
        ),
      );
    });
  }
}

class StaggeredTileExtended extends StaggeredTile {
  const StaggeredTileExtended.count(
      int crossAxisCellCount, num mainAxisCellCount)
      : super.count(crossAxisCellCount, mainAxisCellCount);
}
