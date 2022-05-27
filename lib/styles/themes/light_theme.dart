import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.blue,
    secondary: AppColors.blue,
  ),
  appBarTheme: AppBarTheme(
    color: AppColors.white,
    elevation: 0,
    titleTextStyle: AppTextStyle.xxxLargeBlack,
  ),
  iconTheme: IconThemeData(color: AppColors.black, size: 25),
  textTheme: TextTheme(
    headline1: AppTextStyle.xxxLargeBlackBold,
    headline2: AppTextStyle.xxxLargeBlack,
    headline3: AppTextStyle.xxLargeBlack,
    headline4: AppTextStyle.xxLargeBlueBold,
    headline5: AppTextStyle.xLargeBlue,
    headline6: AppTextStyle.xLargeBlack,
    subtitle1: AppTextStyle.smallBlack,
    bodyText1: AppTextStyle.largeBlack,
    bodyText2: AppTextStyle.mediumBlue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.gray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.blue),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
    errorStyle: AppTextStyle.mediumRed,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: AppColors.blue,
      padding: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);
