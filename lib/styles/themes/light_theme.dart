import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:exservice/utils/sizer.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.blue,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.black,
    secondary: AppColors.blue,
    onSecondary: AppColors.gray,
    secondaryContainer: AppColors.grayAccent,
  ),
  fontFamily: "Poppins",
  primaryColor: AppColors.blue,
  indicatorColor: AppColors.blue,
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(AppColors.white),
    trackColor: MaterialStateProperty.all(AppColors.blue),
  ),
  listTileTheme: const ListTileThemeData(
    style: ListTileStyle.drawer,
    contentPadding: EdgeInsets.symmetric(horizontal: 30),
    iconColor: AppColors.blue,
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(AppColors.blue),
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: AppTextStyle.xLargeBlack,
    toolbarTextStyle: AppTextStyle.xLargeBlack,
    color: Colors.grey[50],
    iconTheme: const IconThemeData(
      color: AppColors.blue,
    ),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.black,
    size: 25,
  ),
  primaryTextTheme: TextTheme(
    displayLarge: AppTextStyle.xxxLargeBlack,
    displayMedium: AppTextStyle.xxLargeBlack,
    displaySmall: AppTextStyle.xLargeBlack,
    bodyLarge: AppTextStyle.largeBlack,
    bodyMedium: AppTextStyle.mediumBlack,
    bodySmall: AppTextStyle.smallBlack,
    labelLarge: AppTextStyle.largeGray,
    labelMedium: AppTextStyle.mediumGray,
    labelSmall: AppTextStyle.smallGray,
    titleLarge: AppTextStyle.xLargeBlue,
    titleMedium: AppTextStyle.mediumBlue,
    titleSmall: AppTextStyle.smallBlue,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 40.sp,
      color: AppColors.black,
      fontFamily: "Satisfy",
    ),
    bodyLarge: AppTextStyle.mediumBlack,
    titleMedium: AppTextStyle.mediumBlack,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    enabledBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.grayAccent),
    ),
    border: UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.grayAccent),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.grayAccent),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.red),
    ),
    labelStyle: AppTextStyle.mediumBlue,
    hintStyle: AppTextStyle.mediumGray,
    errorStyle: AppTextStyle.smallRed,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: AppTextStyle.largeWhite.copyWith(fontWeight: FontWeight.w500),
      primary: AppColors.blue,
      onPrimary: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: AppTextStyle.mediumBlue.copyWith(fontWeight: FontWeight.w400),
      primary: AppColors.blueAccent,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
    ),
  ),
);
