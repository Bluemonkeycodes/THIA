import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/utils/utils.dart';

// ignore: non_constant_identifier_names
Widget GetCheckBoxRow({
  RxBool? value,
  String? text,
  TextStyle? textStyle,
  Color? fillColor,
  Color? checkColor,
  double? borderRadius,
  OutlinedBorder? shape,
  double? size = 25.0,
  double? scaleSize,
  void Function(bool?)? function,
}) {
  return Row(
    children: [
      SizedBox(
        height: size,
        width: size,
        child: Container(
          // padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(border: Border.all(color: (value?.value ?? false) ? AppColors.buttonColor : AppColors.grey), borderRadius: BorderRadius.circular(6)),
          child: Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value?.value ?? false,
            onChanged: function ??
                (val) {
                  value?.value = val ?? false;
                },
            splashRadius: 10.0,
            side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 1, color: Colors.transparent)),
            checkColor: checkColor ?? AppColors.buttonColor,
            activeColor: Colors.transparent,
            hoverColor: AppColors.buttonColor,
            // fillColor: MaterialStateProperty.all(fillColor ?? AppColors.white),
            // shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ),
      const SizedBox(width: 10.0),
      Text(text ?? "", style: textStyle ?? black16w500, overflow: TextOverflow.ellipsis),
    ],
  );
}

// ignore: non_constant_identifier_names
Widget GetImageCheckBox({
  RxBool? value,
  String? text,
  TextStyle? textStyle,
  Function()? ontap,
}) {
  return Row(
    children: [
      GestureDetector(
        onTap: ontap ??
            () {
              value?.toggle();
            },
        child: value?.value == true
            ? Image.asset(
                "assets/images/filled_checkbox.png",
                scale: 3.0,
              )
            : Image.asset(
                "assets/images/simple_checkbox.png",
                scale: 3.0,
              ),
      ),
      const SizedBox(
        width: 10.0,
      ),
      Text(
        text ?? "",
        style: textStyle,
      ),
    ],
  );
}
