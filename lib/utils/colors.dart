import 'package:flutter/material.dart';
import 'package:thia/main.dart';
import 'package:thia/utils/constants.dart';

class AppColors {
  static Color get white => getDarkMode() ? const Color(0xff000000) : const Color(0xffffffff);
  static Color get black => getDarkMode() ? const Color(0xffffffff) : const Color(0xff000000);
  static Color get backgroundColor => getDarkMode() ? const Color(0xff181A20).withOpacity(0.9) : const Color(0xffFAFAFA);
  static Color get textColor => getDarkMode() ? const Color(0xffffffff) : const Color(0xff1C1C1C);
  static Color get grey => AppColors.black.withOpacity(0.3);

  ///
  static Color get red => const Color(0xffF6412D);
  static Color get orange => const Color(0xffFF9800);
  static Color get yellow => const Color(0xffFFEC19);

  // static const Color borderColor = Color(0xff5E61EB);
  // static const Color primaryColor = Color(0xff6C6DEE);
  ///
  static Color get primaryColor => getPrimaryColor();

  // static Color lightPrimaryColor = primaryColor.withOpacity(0.5);
  // static const Color lightPrimaryColor = Color(0xffA69EFE);
  static LinearGradient get purpleGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor, primaryColor.withOpacity(0.6)],
      );

  static LinearGradient get lightPurpleGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor.withOpacity(0.1), primaryColor.withOpacity(0.6).withOpacity(0.1)],
      );
}

Color getPrimaryColor() {
  // showLog("primary color ===> ${getPreference.read(PrefConstants.primaryColor)}");
  return Color(getPreference.read(PrefConstants.primaryColor) ?? 0xff6C6DEE);
}

setPrimaryColor(int color) {
  getPreference.write(PrefConstants.primaryColor, color);
}

setDarkMode(bool isDarkMode) {
  getPreference.write(PrefConstants.isDarkMode, isDarkMode);
}

bool getDarkMode() {
  // showLog("isDarkMode ===> ${getPreference.read(PrefConstants.isDarkMode)}");
  return getPreference.read(PrefConstants.isDarkMode) ?? false;
}
