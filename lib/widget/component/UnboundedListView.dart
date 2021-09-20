import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UnboundedListView = ListView with UnboundedListViewMixin;
mixin UnboundedListViewMixin on ListView {
  @override
  Widget buildChildLayout(BuildContext context) {
    // TODO: support itemExtent
//    if (itemExtent != null) {
//      return UnboundedSliverFixedExtentList(
//        delegate: childrenDelegate,
//        itemExtent: itemExtent,
//      );
//    }
    return UnboundedSliverList(delegate: childrenDelegate);
  }

  @protected
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    // TODO: support shrinkWrap
//    if (shrinkWrap) {
//      return UnboundedShrinkWrappingViewport(
//        axisDirection: axisDirection,
//        offset: offset,
//        slivers: slivers,
//      );
//    }
    return UnboundedViewport(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      cacheExtent: cacheExtent,
    );
  }

  @override
  List<Widget> buildSlivers(BuildContext context) {
    Widget sliver = buildChildLayout(context);
    EdgeInsetsGeometry effectivePadding = padding;
    if (padding == null) {
      final MediaQueryData mediaQuery = MediaQuery.of(context);
      if (mediaQuery != null) {
        // Automatically pad sliver with padding from MediaQuery.
        final EdgeInsets mediaQueryHorizontalPadding =
            mediaQuery.padding.copyWith(top: 0.0, bottom: 0.0);
        final EdgeInsets mediaQueryVerticalPadding =
            mediaQuery.padding.copyWith(left: 0.0, right: 0.0);
        // Consume the main axis padding with SliverPadding.
        effectivePadding = scrollDirection == Axis.vertical
            ? mediaQueryVerticalPadding
            : mediaQueryHorizontalPadding;
        // Leave behind the cross axis padding.
        sliver = MediaQuery(
          data: mediaQuery.copyWith(
            padding: scrollDirection == Axis.vertical
                ? mediaQueryHorizontalPadding
                : mediaQueryVerticalPadding,
          ),
          child: sliver,
        );
      }
    }

    if (effectivePadding != null)
      sliver =
          UnboundedSliverPadding(padding: effectivePadding, sliver: sliver);
    return <Widget>[sliver];
  }
}

class UnboundedSliverPadding = SliverPadding with UnboundedSliverPaddingMixin;
mixin UnboundedSliverPaddingMixin on SliverPadding {
  @override
  RenderSliverPadding createRenderObject(BuildContext context) {
    return UnboundedRenderSliverPadding(
      padding: padding,
      textDirection: Directionality.of(context),
    );
  }
}

class UnboundedRenderSliverPadding = RenderSliverPadding
    with UnboundedRenderSliverPaddingMixin;
mixin UnboundedRenderSliverPaddingMixin on RenderSliverPadding {
  @override
  void performLayout() {
    super.performLayout();
    UnboundedSliverGeometry childGeometry = child.geometry;
    geometry = UnboundedSliverGeometry(
        existing: geometry,
        crossAxisSize: childGeometry.crossAxisSize + padding.vertical);
  }
}

class UnboundedSliverList = SliverList with UnboundedSliverListMixin;
mixin UnboundedSliverListMixin on SliverList {
  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context;
    return UnboundedRenderSliverList(childManager: element);
  }
}

class UnboundedRenderSliverList extends RenderSliverList {
  UnboundedRenderSliverList({
    @required RenderSliverBoxChildManager childManager,
  }) : super(childManager: childManager);

  @override
  void performLayout() {
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    BoxConstraints childConstraints = constraints.asBoxConstraints();
    int leadingGarbage = 0;
    int trailingGarbage = 0;
    bool reachedEnd = false;

    if (constraints.axis == Axis.horizontal) {
      childConstraints = childConstraints.copyWith(minHeight: 0);
    } else {
      childConstraints = childConstraints.copyWith(minWidth: 0);
    }

    double unboundedSize = 0;

    // should call update after each child is laid out
    updateUnboundedSize(RenderBox child) {
      if (child == null) {
        return;
      }
      unboundedSize = math.max(
          unboundedSize,
          constraints.axis == Axis.horizontal
              ? child.size.height
              : child.size.width);
    }

    unboundedGeometry(SliverGeometry geometry) {
      return UnboundedSliverGeometry(
        existing: geometry,
        crossAxisSize: unboundedSize,
      );
    }

    // This algorithm in principle is straight-forward: find the first child
    // that overlaps the given scrollOffset, creating more children at the top
    // of the list if necessary, then walk down the list updating and laying out
    // each child and adding more at the end if necessary until we have enough
    // children to cover the entire viewport.
    //
    // It is complicated by one minor issue, which is that any time you update
    // or create a child, it's possible that the some of the children that
    // haven't yet been laid out will be removed, leaving the list in an
    // inconsistent state, and requiring that missing nodes be recreated.
    //
    // To keep this mess tractable, this algorithm starts from what is currently
    // the first child, if any, and then walks up and/or down from there, so
    // that the nodes that might get removed are always at the edges of what has
    // already been laid out.

    // Make sure we have at least one child to start from.
    if (firstChild == null) {
      if (!addInitialChild()) {
        // There are no children.
        geometry = unboundedGeometry(SliverGeometry.zero);
        childManager.didFinishLayout();
        return;
      }
    }

    // We have at least one child.

    // These variables track the range of children that we have laid out. Within
    // this range, the children have consecutive indices. Outside this range,
    // it's possible for a child to get removed without notice.
    RenderBox leadingChildWithLayout, trailingChildWithLayout;

    // Find the last child that is at or before the scrollOffset.
    RenderBox earliestUsefulChild = firstChild;
    for (double earliestScrollOffset = childScrollOffset(earliestUsefulChild);
        earliestScrollOffset > scrollOffset;
        earliestScrollOffset = childScrollOffset(earliestUsefulChild)) {
      // We have to add children before the earliestUsefulChild.
      earliestUsefulChild =
          insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
      updateUnboundedSize(earliestUsefulChild);

      if (earliestUsefulChild == null) {
        final SliverMultiBoxAdaptorParentData childParentData =
            firstChild.parentData;
        childParentData.layoutOffset = 0.0;

        if (scrollOffset == 0.0) {
          earliestUsefulChild = firstChild;
          leadingChildWithLayout = earliestUsefulChild;
          trailingChildWithLayout ??= earliestUsefulChild;
          break;
        } else {
          // We ran out of children before reaching the scroll offset.
          // We must inform our parent that this sliver cannot fulfill
          // its contract and that we need a scroll offset correction.
          geometry = unboundedGeometry(
            SliverGeometry(
              scrollOffsetCorrection: -scrollOffset,
            ),
          );
          return;
        }
      }

      final double firstChildScrollOffset =
          earliestScrollOffset - paintExtentOf(firstChild);
      if (firstChildScrollOffset < 0.0) {
        // The first child doesn't fit within the viewport (underflow) and
        // there may be additional children above it. Find the real first child
        // and then correct the scroll position so that there's room for all and
        // so that the trailing edge of the original firstChild appears where it
        // was before the scroll offset correction.
        // TODO(hansmuller): do this work incrementally, instead of all at once,
        // i.e. find a way to avoid visiting ALL of the children whose offset
        // is < 0 before returning for the scroll correction.
        double correction = 0.0;
        while (earliestUsefulChild != null) {
          assert(firstChild == earliestUsefulChild);
          correction += paintExtentOf(firstChild);
          earliestUsefulChild = insertAndLayoutLeadingChild(childConstraints,
              parentUsesSize: true);
          updateUnboundedSize(earliestUsefulChild);
        }
        geometry = unboundedGeometry(
          SliverGeometry(
            scrollOffsetCorrection: correction - earliestScrollOffset,
          ),
        );
        final SliverMultiBoxAdaptorParentData childParentData =
            firstChild.parentData;
        childParentData.layoutOffset = 0.0;
        return;
      }

      final SliverMultiBoxAdaptorParentData childParentData =
          earliestUsefulChild.parentData;
      childParentData.layoutOffset = firstChildScrollOffset;
      assert(earliestUsefulChild == firstChild);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout ??= earliestUsefulChild;
    }

    // At this point, earliestUsefulChild is the first child, and is a child
    // whose scrollOffset is at or before the scrollOffset, and
    // leadingChildWithLayout and trailingChildWithLayout are either null or
    // cover a range of render boxes that we have laid out with the first being
    // the same as earliestUsefulChild and the last being either at or after the
    // scroll offset.

    assert(earliestUsefulChild == firstChild);
    assert(childScrollOffset(earliestUsefulChild) <= scrollOffset);

    // Make sure we've laid out at least one child.
    if (leadingChildWithLayout == null) {
      earliestUsefulChild.layout(childConstraints, parentUsesSize: true);
      updateUnboundedSize(earliestUsefulChild);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout = earliestUsefulChild;
    }

    // Here, earliestUsefulChild is still the first child, it's got a
    // scrollOffset that is at or before our actual scrollOffset, and it has
    // been laid out, and is in fact our leadingChildWithLayout. It's possible
    // that some children beyond that one have also been laid out.

    bool inLayoutRange = true;
    RenderBox child = earliestUsefulChild;
    int index = indexOf(child);
    double endScrollOffset = childScrollOffset(child) + paintExtentOf(child);
    bool advance() {
      // returns true if we advanced, false if we have no more children
      // This function is used in two different places below, to avoid code duplication.
      assert(child != null);
      if (child == trailingChildWithLayout) inLayoutRange = false;
      child = childAfter(child);
      if (child == null) inLayoutRange = false;
      index += 1;
      if (!inLayoutRange) {
        if (child == null || indexOf(child) != index) {
          // We are missing a child. Insert it (and lay it out) if possible.
          child = insertAndLayoutChild(
            childConstraints,
            after: trailingChildWithLayout,
            parentUsesSize: true,
          );
          updateUnboundedSize(child);
          if (child == null) {
            // We have run out of children.
            return false;
          }
        } else {
          // Lay out the child.
          child.layout(childConstraints, parentUsesSize: true);
          updateUnboundedSize(child);
        }
        trailingChildWithLayout = child;
      }
      assert(child != null);
      final SliverMultiBoxAdaptorParentData childParentData = child.parentData;
      childParentData.layoutOffset = endScrollOffset;
      assert(childParentData.index == index);
      endScrollOffset = childScrollOffset(child) + paintExtentOf(child);
      return true;
    }

    // Find the first child that ends after the scroll offset.
    while (endScrollOffset < scrollOffset) {
      leadingGarbage += 1;
      if (!advance()) {
        assert(leadingGarbage == childCount);
        assert(child == null);
        // we want to make sure we keep the last child around so we know the end scroll offset
        collectGarbage(leadingGarbage - 1, 0);
        assert(firstChild == lastChild);
        final double extent =
            childScrollOffset(lastChild) + paintExtentOf(lastChild);
        geometry = unboundedGeometry(
          SliverGeometry(
            scrollExtent: extent,
            paintExtent: 0.0,
            maxPaintExtent: extent,
          ),
        );
        return;
      }
    }

    // Now find the first child that ends after our end.
    while (endScrollOffset < targetEndScrollOffset) {
      if (!advance()) {
        reachedEnd = true;
        break;
      }
    }

    // Finally count up all the remaining children and label them as garbage.
    if (child != null) {
      child = childAfter(child);
      while (child != null) {
        trailingGarbage += 1;
        child = childAfter(child);
      }
    }

    // At this point everything should be good to go, we just have to clean up
    // the garbage and report the geometry.

    collectGarbage(leadingGarbage, trailingGarbage);

    assert(debugAssertChildListIsNonEmptyAndContiguous());
    double estimatedMaxScrollOffset;
    if (reachedEnd) {
      estimatedMaxScrollOffset = endScrollOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild),
        lastIndex: indexOf(lastChild),
        leadingScrollOffset: childScrollOffset(firstChild),
        trailingScrollOffset: endScrollOffset,
      );
      assert(estimatedMaxScrollOffset >=
          endScrollOffset - childScrollOffset(firstChild));
    }
    final double paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild),
      to: endScrollOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: childScrollOffset(firstChild),
      to: endScrollOffset,
    );
    final double targetEndScrollOffsetForPaint =
        constraints.scrollOffset + constraints.remainingPaintExtent;
    geometry = unboundedGeometry(
      SliverGeometry(
        scrollExtent: estimatedMaxScrollOffset,
        paintExtent: paintExtent,
        cacheExtent: cacheExtent,
        maxPaintExtent: estimatedMaxScrollOffset,
        // Conservative to avoid flickering away the clip during scroll.
        hasVisualOverflow: endScrollOffset > targetEndScrollOffsetForPaint ||
            constraints.scrollOffset > 0.0,
      ),
    );

    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.
    if (estimatedMaxScrollOffset == endScrollOffset)
      childManager.setDidUnderflow(true);
    childManager.didFinishLayout();
  }
}

class UnboundedViewport = Viewport with UnboundedViewportMixin;
mixin UnboundedViewportMixin on Viewport {
  @override
  RenderViewport createRenderObject(BuildContext context) {
    return UnboundedRenderViewport(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
    );
  }
}

class UnboundedRenderViewport = RenderViewport
    with UnboundedRenderViewportMixin;
mixin UnboundedRenderViewportMixin on RenderViewport {
  @override
  bool get sizedByParent => false;

  double _unboundedSize = double.infinity;

  @override
  void performLayout() {
    BoxConstraints constraints = this.constraints;
    if (axis == Axis.horizontal) {
      _unboundedSize = constraints.maxHeight;
      size = Size(constraints.maxWidth, 0);
    } else {
      _unboundedSize = constraints.maxWidth;
      size = Size(0, constraints.maxHeight);
    }

    super.performLayout();

    switch (axis) {
      case Axis.vertical:
        offset.applyViewportDimension(size.height);
        break;
      case Axis.horizontal:
        offset.applyViewportDimension(size.width);
        break;
    }
  }

  @override
  double layoutChildSequence({
    @required RenderSliver child,
    @required double scrollOffset,
    @required double overlap,
    @required double layoutOffset,
    @required double remainingPaintExtent,
    @required double mainAxisExtent,
    @required double crossAxisExtent,
    @required GrowthDirection growthDirection,
    @required RenderSliver advance(RenderSliver child),
    @required double remainingCacheExtent,
    @required double cacheOrigin,
  }) {
    crossAxisExtent = _unboundedSize;
    var firstChild = child;

    final result = super.layoutChildSequence(
      child: child,
      scrollOffset: scrollOffset,
      overlap: overlap,
      layoutOffset: layoutOffset,
      remainingPaintExtent: remainingPaintExtent,
      mainAxisExtent: mainAxisExtent,
      crossAxisExtent: crossAxisExtent,
      growthDirection: growthDirection,
      advance: advance,
      remainingCacheExtent: remainingCacheExtent,
      cacheOrigin: cacheOrigin,
    );

    double unboundedSize = 0;
    while (firstChild != null) {
      if (firstChild.geometry is UnboundedSliverGeometry) {
        final UnboundedSliverGeometry childGeometry = firstChild.geometry;
        unboundedSize = math.max(unboundedSize, childGeometry.crossAxisSize);
      }
      firstChild = advance(firstChild);
    }
    if (axis == Axis.horizontal) {
      size = Size(size.width, unboundedSize);
    } else {
      size = Size(unboundedSize, size.height);
    }

    return result;
  }
}

class UnboundedSliverGeometry extends SliverGeometry {
  UnboundedSliverGeometry({SliverGeometry existing, this.crossAxisSize})
      : super(
          scrollExtent: existing.scrollExtent,
          paintExtent: existing.paintExtent,
          paintOrigin: existing.paintOrigin,
          layoutExtent: existing.layoutExtent,
          maxPaintExtent: existing.maxPaintExtent,
          maxScrollObstructionExtent: existing.maxScrollObstructionExtent,
          hitTestExtent: existing.hitTestExtent,
          visible: existing.visible,
          hasVisualOverflow: existing.hasVisualOverflow,
          scrollOffsetCorrection: existing.scrollOffsetCorrection,
          cacheExtent: existing.cacheExtent,
        );

  final double crossAxisSize;
}
