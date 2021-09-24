import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDurationFromInt(int duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration ~/ 60);
    String twoDigitSeconds = twoDigits(duration % 60);
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static EdgeInsets loginFormPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (6 / 100),
        left: mediaQuery.size.width * (6 / 100),
        bottom: mediaQuery.size.height * (5 / 100),
        top: mediaQuery.size.height * (10 / 100));
  }

  static EdgeInsets verificationPinCodePadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (6 / 100),
        left: mediaQuery.size.width * (6 / 100),
        bottom: mediaQuery.size.height * (5 / 100),
        top: mediaQuery.size.height * (10 / 100));
  }

  static EdgeInsets resetPasswordPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (6 / 100),
        left: mediaQuery.size.width * (6 / 100),
        bottom: mediaQuery.size.height * (5 / 100),
        top: mediaQuery.size.height * (2 / 100));
  }

  static EdgeInsets forgetPasswordPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (6 / 100),
        left: mediaQuery.size.width * (6 / 100),
        bottom: mediaQuery.size.height * (5 / 100),
        top: mediaQuery.size.height * (2 / 100));
  }

  static EdgeInsets verificationPinCodeBackButtonPadding(
      MediaQueryData mediaQuery) {
    return EdgeInsets.only(
      left: 10,
    );
  }

  static EdgeInsets paymentRequestPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (6 / 100),
        left: mediaQuery.size.width * (6 / 100));
  }

  static EdgeInsets pendingCardMargin(MediaQueryData mediaQuery) {
    return EdgeInsets.symmetric(
        vertical: mediaQuery.size.width * (3 / 100),
        horizontal: mediaQuery.size.width * (6 / 100));
  }

  static EdgeInsets pendingRequestPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.all(mediaQuery.size.width * (6 / 100));
  }

  static EdgeInsets forgetPasswordBottomSheetPadding(
      MediaQueryData mediaQuery) {
    return EdgeInsets.only(
      right: mediaQuery.size.width * (6 / 100),
      left: mediaQuery.size.width * (6 / 100),
      bottom: mediaQuery.size.height * (3 / 100),
    );
  }

  static EdgeInsets paymentRequestBottomSheetPadding(
      MediaQueryData mediaQuery) {
    return EdgeInsets.symmetric(
      vertical: mediaQuery.size.height * (2 / 100),
      horizontal: mediaQuery.size.width * (4 / 100),
    );
  }

  static EdgeInsets aboutUsPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
      right: mediaQuery.size.width * (6 / 100),
      left: mediaQuery.size.width * (6 / 100),
      bottom: mediaQuery.size.width * (1.5 / 100),
    );
  }

  static EdgeInsets contactUsPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (6 / 100),
        left: mediaQuery.size.width * (6 / 100),
        bottom: mediaQuery.size.width * (6 / 100),
        top: mediaQuery.size.width * (6 / 100));
  }

  static double verticalSpace(MediaQueryData mediaQuery) {
    return mediaQuery.size.height * (2 / 100);
  }

  static double horizontalSpace(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (5 / 100);
  }

  static double iconSize(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (6 / 100);
  }

  static double iconAppBarSize(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (7 / 100);
  }

  static double buttonBorderRadius(MediaQueryData mediaQuery) {
    return mediaQuery.size.height * (1 / 100);
  }

  static EdgeInsets buttonContentPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.symmetric(vertical: mediaQuery.size.height * (2 / 100));
  }

  static passwordValidatorWidth(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (15 / 100);
  }

  static profileFormPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (6 / 100),
        left: mediaQuery.size.width * (6 / 100),
        bottom: mediaQuery.size.height * (5 / 100),
        top: mediaQuery.size.height * (1 / 100));
  }

  static BorderRadius bottomSheetBorderRadius(MediaQueryData mediaQuery) {
    return BorderRadius.only(
      topLeft: Radius.circular(mediaQuery.size.width * 0.1),
      topRight: Radius.circular(mediaQuery.size.width * 0.1),
    );
  }

  static double borderRadiusDropdownButton(MediaQueryData mediaQuery) {
    return mediaQuery.size.height * (1 / 100);
  }

  static filterIconPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
        right: mediaQuery.size.width * (3 / 100),
        left: mediaQuery.size.width * (3 / 100),
        top: mediaQuery.size.width * (3 / 100),
        bottom: mediaQuery.size.width * (3 / 100));
  }

  static double dayCardWidth(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (25 / 100);
  }

  static double dayCardHeight(MediaQueryData mediaQuery) {
    return mediaQuery.size.height * (12.5 / 100);
  }

  static double dayBorderRadius(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (5 / 100);
  }

  static double pendingRadius(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (3 / 100);
  }

  static EdgeInsets dayCardMargin(MediaQueryData mediaQuery) {
    return EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * (2 / 100), vertical: 5);
  }

  static double iconBorderRadius(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (100 / 100);
  }

  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat("dd/MM/yyyy");
    return formatter.format(dateTime);
  }

  static String formatDateName(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMMMMd('en_US');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.jm();
    return formatter.format(dateTime);
  }

  static double cardBorderRadius(mediaQuery) {
    return mediaQuery.size.height * (1.5 / 100);
  }

  static double removeCardRadius(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (4 / 100);
  }

  static EdgeInsets appBarPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.only(
      left: mediaQuery.size.width * (5 / 100),
      right: mediaQuery.size.width * (5 / 100),
      top: mediaQuery.size.height * (5 / 100),
      bottom: mediaQuery.size.height * (2 / 100),
    );
  }

  static EdgeInsets appBarHorizontalPadding(MediaQueryData mediaQuery) {
    return EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.05);
  }
}
