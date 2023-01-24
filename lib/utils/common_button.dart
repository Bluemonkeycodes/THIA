import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'font_styles.dart';

// ignore: non_constant_identifier_names
Widget GetButton({
  double? height = 58,
  double? width,
  Border? border,
  Color? backGroundColor,
  Widget? child,
  double? borderRadius,
  double? margin = 0,
  bool? isBorder,
  String? text,
  TextStyle? textStyle,
  Gradient? gradient,
  EdgeInsets? padding,
  required Function() ontap,
}) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      height: height,
      width: width,
      padding: padding,
      margin: EdgeInsets.all(margin ?? 0),
      decoration: BoxDecoration(
          border: isBorder != null
              ? isBorder
                  ? border
                  : Border.all(
                      color: Colors.transparent,
                    )
              : Border.all(
                  color: Colors.transparent,
                ),
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          color: backGroundColor ?? AppColors.buttonColor,
          gradient: gradient),
      // ignore: prefer_if_null_operators
      child: child ?? Center(child: Text(text ?? "", style: textStyle ?? white16w500)),
    ),
  );
}

// // ignore: non_constant_identifier_names
// Widget GetSelectedButton({
//   double? height = 50,
//   double? width,
//   Border? border,
//   Color? backGroundColor,
//   Widget? child,
//   double? borderRadius,
//   bool? isBorder,
//   String? text,
//   TextStyle? textStyle,
//   required RxBool isSelected,
//   required Function() ontap,
// }) {
//   return GestureDetector(
//     onTap: ontap,
//     child: Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         border: isBorder != null
//             ? isBorder
//                 ? border
//                 : Border.all(
//                     color: Colors.transparent,
//                   )
//             : Border.all(
//                 color: Colors.transparent,
//               ),
//         borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
//         color: backGroundColor ?? AppColors.primaryColor,
//       ),
//       // ignore: prefer_if_null_operators
//       child: child != null ? child : Center(
//           child: Text(
//         text ?? "",
//         style: textStyle,
//       )),
//     ),
//   );
// }
