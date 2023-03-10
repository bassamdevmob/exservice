import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:exservice/utils/sizer.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: AppColors.blue,
    onPrimary: AppColors.black,
    primaryContainer: AppColors.white,
    secondary: AppColors.blue,
    onSecondary: AppColors.grayAccent,
    secondaryContainer: AppColors.gray,
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
    titleTextStyle: AppTextStyle.xLargeWhite,
    toolbarTextStyle: AppTextStyle.xLargeWhite,
    color: Colors.grey[850],
    iconTheme: const IconThemeData(
      color: AppColors.blue,
    ),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.white,
    size: 25,
  ),
  primaryTextTheme: TextTheme(
    displayLarge: AppTextStyle.xxxLargeWhite,
    displayMedium: AppTextStyle.xxLargeWhite,
    displaySmall: AppTextStyle.xLargeWhite,
    bodyLarge: AppTextStyle.largeWhite,
    bodyMedium: AppTextStyle.mediumWhite,
    bodySmall: AppTextStyle.smallWhite,
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
      color: AppColors.white,
      fontFamily: "Satisfy"
    ),
    bodyLarge: AppTextStyle.mediumWhite,
    titleMedium: AppTextStyle.mediumWhite,
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
        borderRadius: BorderRadius.circular(10),
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
