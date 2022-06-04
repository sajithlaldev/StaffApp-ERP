import 'package:flutter/material.dart';
import 'colors.dart';

class Styles {
  static final DEFAULT_ELEVATED_BUTTON_THEME = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AppColors.primary),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: 15,
        ),
      ),
      fixedSize: MaterialStateProperty.all(
        const Size(double.infinity, 42),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    ),
  );

  static final SECONDARY_ELEVATED_BUTTON_THEME = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppColors.accent),
    foregroundColor: MaterialStateProperty.all(
      AppColors.primary,
    ),
    overlayColor: MaterialStateProperty.all(
      AppColors.primary.withOpacity(0.1),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(
          color: AppColors.primary,
        ),
      ),
    ),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 15,
      ),
    ),
    textStyle: MaterialStateProperty.all(
      const TextStyle(
        color: AppColors.primary,
        fontSize: 12,
      ),
    ),
  );

  static final DEFAULT_TEXT_DECORATION = InputDecoration(
    border: BORDER,
    focusedBorder: ACTIVE_BORDER,
    enabledBorder: BORDER,
    disabledBorder: BORDER,
    hintStyle: const TextStyle(color: Colors.black),
    fillColor: AppColors.accent,
    isDense: true,
    filled: true,
  );

  static final BORDER = OutlineInputBorder(
    borderRadius: BorderRadius.circular(0),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 203, 203, 203),
      width: 0.7,
    ),
  );
  static final ACTIVE_BORDER = OutlineInputBorder(
    borderRadius: BorderRadius.circular(0),
    borderSide: const BorderSide(
      color: AppColors.primary,
      width: 0.7,
    ),
  );

  static const DEFAULT_TEXT_THEME = TextTheme(
    headline2: TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    bodyText1: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
  );

  static final boxShadow = BoxShadow(
    blurRadius: 10,
    color: Colors.black.withOpacity(0.6),
    spreadRadius: 4,
    offset: const Offset(0, 4),
  );

  static BoxDecoration boxDecoration(bool isActive,
          {double? elevation,
          double? spreadRadius,
          double? cornerRadius,
          Color? color,
          Color? bgColor}) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius ?? 4),
        color: bgColor ?? AppColors.primary,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: color ?? Colors.black.withOpacity(0.2),
            spreadRadius: spreadRadius ?? 1,
            offset: Offset(0, elevation ?? 1),
          ),
        ],
      );
}
