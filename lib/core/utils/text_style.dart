import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_fonts.dart';

import 'colors.dart';

TextStyle getTitleStyle(
    {Color? color,
      double? fontSize = 18,
      FontWeight? fontWeight = FontWeight.bold}) =>
    TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.primaryColor,
      fontWeight: fontWeight,
      fontFamily: AppFonts.cairo,
    );

TextStyle getBodyStyle(BuildContext context,
    {Color? color,
      double? fontSize = 14,
      FontWeight? fontWeight = FontWeight.w400}) =>
    TextStyle(
        fontSize: fontSize,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontWeight: fontWeight,
        fontFamily: AppFonts.cairo,
    );

TextStyle getSmallStyle(
    {Color? color,
      double? fontSize = 12,
      FontWeight? fontWeight = FontWeight.w500}) =>
    TextStyle(
        fontSize: fontSize,
        color: color ?? AppColors.darkColor,
        fontWeight: fontWeight,
        fontFamily: AppFonts.cairo,
    );