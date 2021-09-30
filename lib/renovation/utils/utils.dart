import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Utils {
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

  static EdgeInsets forgetPasswordBottomSheetPadding(
      MediaQueryData mediaQuery) {
    return EdgeInsets.only(
      right: mediaQuery.size.width * (6 / 100),
      left: mediaQuery.size.width * (6 / 100),
      bottom: mediaQuery.size.height * (3 / 100),
    );
  }

  static double verticalSpace(MediaQueryData mediaQuery) {
    return mediaQuery.size.height * (2 / 100);
  }

  static double iconSize(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (6 / 100);
  }

  static passwordValidatorWidth(MediaQueryData mediaQuery) {
    return mediaQuery.size.width * (15 / 100);
  }

  static BorderRadius bottomSheetBorderRadius(MediaQueryData mediaQuery) {
    return BorderRadius.only(
      topLeft: Radius.circular(mediaQuery.size.width * 0.1),
      topRight: Radius.circular(mediaQuery.size.width * 0.1),
    );
  }

  static double cardBorderRadius(mediaQuery) {
    return mediaQuery.size.height * (1.5 / 100);
  }

  static Future<void> launchWeb(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw "${AppLocalization.of(context).trans("siteFailed")}: $url";
    }
  }

  static Future<void> launchMail(BuildContext context, String mail) async {
    final path =
    Uri(scheme: 'mailto', path: mail, queryParameters: {'subject': 'hi '})
        .toString();
    if (await canLaunch(path)) {
      await launch(path);
    } else {
      throw "${AppLocalization.of(context).trans("emailFailed")}: $mail";
    }
  }

  static Future<void> launchCall(BuildContext context, String number) async {
    var path = "tel:$number";
    if (await canLaunch(path)) {
      await launch(path);
    } else {
      throw "${AppLocalization.of(context).trans("callFailed")}: $number";
    }
  }

  static bool isPhoneNumber(String value) =>
      value != null && phoneRegex.hasMatch(value);
}
