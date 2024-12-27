
import 'package:flutter/material.dart';
import 'package:se7ety/core/utils/text_style.dart';

import '../constants/app_fonts.dart';
import 'colors.dart';
class AppTheme{
  static final lightMode=ThemeData(
      colorScheme: ColorScheme.fromSeed(
          onSurfaceVariant: AppColors.darkColor,
          seedColor: AppColors.primaryColor,
          onPrimary: AppColors.primaryColor,
          onSurface: AppColors.darkColor,
          onSecondary: AppColors.whiteColor,
          outline: Colors.black,
          onPrimaryFixed: AppColors.whiteColor,
          onTertiary: AppColors.whiteColor
      ),
      timePickerTheme: const TimePickerThemeData(
          backgroundColor: AppColors.whiteColor,
          dialBackgroundColor: AppColors.whiteColor),
      datePickerTheme:
      const DatePickerThemeData(backgroundColor: AppColors.whiteColor),
      fontFamily: AppFonts.cairo,
      scaffoldBackgroundColor: AppColors.whiteColor,
      appBarTheme:
      const AppBarTheme(backgroundColor: AppColors.whiteColor),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: AppColors.accentColor,
          hintStyle:
          getSmallStyle(color: AppColors.greyColor),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: AppColors.color2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: AppColors.primaryColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: AppColors.redColor)))
  );
  static final darkMode=ThemeData(
      colorScheme: ColorScheme.fromSeed(
          onSecondaryFixed: AppColors.primaryColor,
          onSurfaceVariant: AppColors.whiteColor,
          onPrimary: AppColors.whiteColor,
          seedColor: AppColors.whiteColor,
          onSurface: AppColors.whiteColor,
          onSecondary: AppColors.darkColor,
          outline: Colors.black,
        onPrimaryFixed: AppColors.primaryColor,
        onTertiary: AppColors.secondaryColor
      ),
      timePickerTheme: const TimePickerThemeData(
          backgroundColor: AppColors.darkColor,
          dialBackgroundColor: AppColors.darkColor
      ),
      datePickerTheme:
      const DatePickerThemeData(backgroundColor: AppColors.darkColor),
      fontFamily: AppFonts.cairo,
      scaffoldBackgroundColor: AppColors.darkColor,
      appBarTheme:
      const AppBarTheme(backgroundColor: AppColors.darkColor),
      inputDecorationTheme: InputDecorationTheme(

          fillColor: AppColors.accentColor,
          hintStyle:
          getSmallStyle(color: AppColors.greyColor),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: AppColors.color2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: AppColors.primaryColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: AppColors.redColor)))
  );

}