import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final kPhoneRegex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

class Utils {
  static List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static String convertMonthToWord(BuildContext context, int month) {
    return AppLocalization.of(context).trans(months[month]);
  }

  static List<String> days = ['mon', 'tue', 'wen', 'thu', 'fri', 'sat', 'sun'];

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
      value != null && kPhoneRegex.hasMatch(value);
}
