import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color red = Color(0xffF6412D);
  static const Color orange = Color(0xffFF9800);
  static const Color yellow = Color(0xffFFEC19);
  static const Color primaryColor = Color(0xff6C6DEE);
  static const Color lightPrimaryColor = Color(0xffA69EFE);
  static const Color borderColor = Color(0xff5E61EB);
  static Color grey = AppColors.black.withOpacity(0.3);
  static const Color blue = Color(0xff2697FF);
  static const Color textColor = Color(0xff1C1C1C);
  static const Color backgroundColor = Color(0xff1E1E1E);
  static LinearGradient purpleGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [borderColor, lightPrimaryColor],
  );

  static LinearGradient lightPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [borderColor.withOpacity(0.1), lightPrimaryColor.withOpacity(0.1)],
  );
}
