import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/global.dart';
import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';

abstract class Utils {
  static final _phoneNumberUtil = PhoneNumberUtil();

  static String resolveErrorMessage(error) {
    if (error is SocketException) {
      return "no_internet".translate();
    } else if (error is TimeoutException) {
      return "connection_timeout".translate();
    } else {
      return error.toString();
    }
  }

  static double estimateBruteforceStrength(String password) {
    if (password.isEmpty) return 0.0;
    double charsetBonus;
    if (RegExp(r'^[0-9]*$').hasMatch(password)) {
      charsetBonus = 0.8;
    } else if (RegExp(r'^[a-z]*$').hasMatch(password)) {
      charsetBonus = 1.0;
    } else if (RegExp(r'^[a-z0-9]*$').hasMatch(password)) {
      charsetBonus = 1.2;
    } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {
      charsetBonus = 1.3;
    } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
      charsetBonus = 1.3;
    } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
      charsetBonus = 1.5;
    } else {
      charsetBonus = 1.8;
    }
    final logisticFunction = (double x) {
      return 1.0 / (1.0 + exp(-x));
    };
    final curve = (double x) {
      return logisticFunction((x / 3.0) - 4.0);
    };

    return curve(password.length * charsetBonus);
  }

  static Future<PhoneNumber> formatPhoneNumber(String number) {
    return _phoneNumberUtil.parse(number);
  }

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




  static bool isPhoneNumber(String value) =>
      value != null && phoneRegex.hasMatch(value);
}

class UsernameFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    var text = newValue.text.split(" ").map((word) {
      if (word.length == 0) return word;
      if (word.length == 1) return word.toUpperCase();
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    });
    return TextEditingValue(
      text: text.join(" "),
      selection: newValue.selection,
    );
  }
}
