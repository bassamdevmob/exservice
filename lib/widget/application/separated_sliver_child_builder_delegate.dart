import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class SeparatedSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  final NullableIndexedWidgetBuilder itemBuilder;
  final NullableIndexedWidgetBuilder separatorBuilder;

  SeparatedSliverChildBuilderDelegate({
    this.itemBuilder,
    this.separatorBuilder,
    int childCount,
  }) : super(
          (ctx, index) => index.isOdd
              ? separatorBuilder(ctx, index ~/ 2)
              : itemBuilder(ctx, index ~/ 2),
          childCount:
              childCount == null ? null : math.max(0, childCount * 2 - 1),
        );
}
