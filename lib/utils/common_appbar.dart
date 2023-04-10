import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import 'font_styles.dart';

// ignore: non_constant_identifier_names
PreferredSize GetAppBar(BuildContext context, String title,
    {bool isTransparent = false,
    List<Widget> actionWidgets = const [],
    Function? backButtonCallBack,
    PreferredSizeWidget? bottom,
    Widget? leadingIcon,
    double? height,
    double? elevation,
    bool? isCenterTitle,
    Widget? child,
    Color? bgColor,
    Color? leadingColor,
    TextStyle? titleStyle,
    ShapeBorder? shape}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(height ?? 60.0),
    child: AppBar(
      bottom: bottom,
      elevation: elevation ?? 1,
      backgroundColor: bgColor ?? AppColors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      centerTitle: isCenterTitle ?? true,
      shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      leading: InkWell(
        onTap: () {
          if (backButtonCallBack != null) {
            backButtonCallBack();
          } else {
            Get.back();
          }
        },
        child: leadingIcon ?? Icon(Icons.arrow_back_ios, color: leadingColor ?? AppColors.black, size: 20),
      ),
      title: child ??
          Container(
            margin: const EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 10),
            child: Text(title, textAlign: TextAlign.center, style: titleStyle ?? black20w600),
          ),
      actions: actionWidgets,
      // actions: actions != null ? actions : null,
    ),
  );
}
