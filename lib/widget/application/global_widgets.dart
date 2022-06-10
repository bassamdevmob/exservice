import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter/material.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

final simpleShimmer = Shimmer.fromColors(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[100],
  child: ColoredBox(
    color: Colors.white,
  ),
);

class BottomSheetStroke extends StatelessWidget {
  final Color color;

  const BottomSheetStroke({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 15.w,
      height: 4,
      decoration: BoxDecoration(
        color: color ?? AppColors.grayAccent,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

ImageProvider resolveProvider(BaseMedia baseMedia){
  if(baseMedia is Media){
    return NetworkImage(baseMedia.link);
  }
  if(baseMedia is ReviewMedia){
    return MemoryImage(baseMedia.data);
  }
  throw Exception("NOT IMPLEMENTED");
}

Widget imageErrorBuilder(ctx, error, _) => const ColoredBox(
      color: AppColors.blue,
    );

class StackLoaderIndicator {
  GlobalKey _key;

  Future<dynamic> show(BuildContext context) async {
    if (_key == null) {
      _key = GlobalKey();
      return showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            key: _key,
            onWillPop: () async => false,
            child: SpinKitCircle(
              size: Theme.of(context).iconTheme.size,
              color: AppColors.blue,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        barrierDismissible: false,
      );
    }
  }

  bool dismiss() {
    if (_key == null) {
      return false;
    } else if (_key.currentState == null) {
      _key = null;
      return false;
    } else {
      Navigator.of(_key.currentContext).pop();
      _key = null;
      return true;
    }
  }
}

Widget getTrailing(BuildContext context) {
  return Icon(
    Directionality.of(context) == TextDirection.ltr
        ? Icons.keyboard_arrow_right
        : Icons.keyboard_arrow_left,
    size: Sizer.iconSizeLarge,
    color: AppColors.blue,
  );
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
