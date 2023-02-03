import 'package:flutter/material.dart';
import 'package:thia/utils/utils.dart';

// ignore: non_constant_identifier_names
Widget GetDropDown({
  String? selectedValue,
  required List<String> selectionData,
  Function? callback,
  double height = 50,
  String hint = "",
  Color? filledColor,
  EdgeInsetsGeometry? padding,
  double? borderRadius,
  double? menuHeight,
  Border? border,
  TextStyle? textStyle,
  Color? iconColor,
}) {
  return Container(
    decoration: BoxDecoration(
        border: border ?? Border.all(color: AppColors.grey.withOpacity(0.5)),
        color: filledColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.0)),
    padding: padding ?? const EdgeInsets.only(right: 12),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4).copyWith(right: 0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: iconColor ?? AppColors.grey),
              iconSize: 22,
              elevation: 16,
              borderRadius: BorderRadius.circular(12),
              style: textStyle ?? black16w500.copyWith(fontSize: 15),
              underline: Container(height: 0, color: Colors.transparent),
              onChanged: (String? newValue) {
                // selectedValue = newValue!;
                callback!(newValue);
              },
              hint: Text(hint, style: grey14w500),
              dropdownColor: AppColors.white,
              menuMaxHeight: menuHeight,
              items: selectionData.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget getDropDownField({
  String? selectedValue,
  required List<String> selectionData,
  required Function callback,
  String? hint,
  double? maxHeight,
  Color? filledColor,
  EdgeInsetsGeometry? contentPadding,
  InputBorder? border,
  TextStyle? textStyle,
}) {
  return DropdownButtonFormField(
    dropdownColor: AppColors.white,
    menuMaxHeight: maxHeight ?? 250,
    hint: Text(hint ?? "Select", style: white16w500.copyWith(color: AppColors.grey)),
    value: selectedValue,
    style: textStyle ?? black16w500.copyWith(fontSize: 15),
    icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.grey),
    decoration: InputDecoration(
      fillColor: filledColor ?? Colors.transparent,
      filled: false,
      focusColor: AppColors.white,
      contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(13, 16, 13, 16),
      border: border ?? outLineBorderStyle,
      enabledBorder: border ?? outLineBorderStyle,
      focusedBorder: border ?? textFieldBorderStyle,
      disabledBorder: border ?? outLineBorderStyle,
      errorBorder: errorBorder,
    ),
    items: selectionData.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(value: value, child: Text(value, style: black16w500));
    }).toList(),
    onChanged: (value) {
      callback(value);
    },
  );
}
