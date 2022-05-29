import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

abstract class Sizer {
  static final Size screenSize = window.physicalSize / window.devicePixelRatio;

  static const Size defaultSize = Size(360, 690);

  static final EdgeInsets padding = EdgeInsets.only(
    left: window.padding.left / window.devicePixelRatio,
    right: window.padding.right / window.devicePixelRatio,
    top: window.padding.top / window.devicePixelRatio,
    bottom: window.padding.bottom / window.devicePixelRatio,
  );

  static final double scaleWidth = screenSize.width / defaultSize.width;

  static final double scaleHeight = screenSize.height / defaultSize.height;

  static double get scaleText => min(scaleWidth, scaleHeight);

  /// vertical spacing
  static double get vs1 => 4.h;

  static double get vs2 => 3.h;

  static double get vs3 => 2.h;

  /// horizontal spacing
  static double get hs1 => 10.w;

  static double get hs2 => 8.w;

  static double get hs3 => 6.w;

  /// icon size
  static double get logoSize => 100.sp;

  static double get avatarSizeLarge => 70.sp;

  static double get avatarSizeSmall => 50.sp;

  static double get iconSizeLarge => 30.sp;

  static double get iconSizeMedium => 20.sp;

  /// EdgeInsets
  static EdgeInsets get authPadding => const EdgeInsets.all(20);

  static EdgeInsets get scaffoldPadding =>
      EdgeInsets.fromLTRB(hs2, vs3, hs2, vs2);

  static EdgeInsets get bottomSheetPadding =>
      EdgeInsets.fromLTRB(hs3, vs3, hs3, vs1);

  /// BorderRadius
  static BorderRadius get bottomSheetBorderRadius =>
      const BorderRadius.vertical(top: Radius.circular(10));
}

extension SizerExtention on num {
  double get h => this * Sizer.screenSize.height / 100;

  double get w => this * Sizer.screenSize.width / 100;

  double get sp => this * Sizer.scaleText;
}
