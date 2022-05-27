import 'package:flutter/material.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

final simpleShimmer = Shimmer.fromColors(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[100],
  child: ColoredBox(
    color: Colors.white,
  ),
);

class LineBottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: Utils.passwordValidatorWidth(MediaQuery.of(context)),
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.lightGray.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}


class ExpandedSingleChildScrollView extends StatelessWidget {
  final Widget child;

  const ExpandedSingleChildScrollView({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}