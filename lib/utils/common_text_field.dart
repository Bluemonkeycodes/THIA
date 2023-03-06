// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thia/utils/utils.dart';

OutlineInputBorder textFieldBorderStyle = OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(15.0));
OutlineInputBorder outLineBorderStyle = OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(15.0));
OutlineInputBorder errorBorder = OutlineInputBorder(borderSide: const BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.circular(15.0));
// ignore: non_constant_identifier_names

Widget GetTextField({
  TextStyle? textStyle,
  int? maxLength,
  String? fieldTitleText,
  required String hintText,
  bool isPassword = false,
  TextEditingController? textEditingController,
  Function? validationFunction,
  Function? onSavedFunction,
  Function? onFieldSubmit,
  TextInputType? keyboardType,
  Function? onEditingComplete,
  Function? onTapFunction,
  Function? onChangedFunction,
  TextAlign align = TextAlign.start,
  TextInputAction? inputAction,
  List<TextInputFormatter>? inputFormatter,
  bool? isEnabled,
  int? errorMaxLines,
  // String? initialText = "",
  int? maxLine,
  FocusNode? textFocusNode,
  GlobalKey<FormFieldState>? key,
  bool isReadOnly = false,
  Widget? suffixIcon,
  Widget? preFixIcon,
  bool? isFilled,
  Color? filledColor,
  RxBool? showPassword,
  EdgeInsetsGeometry? contentPadding,
  ScrollController? scrollController,
  TextStyle? hintStyle,
  OutlineInputBorder? outlineInputBorder,
  UnderlineInputBorder? underlineInputBorder,
  String? label,
  String? title,
  TextStyle? labelTextStyle,
  bool? showSuffixIcon = true,
  Color? cursorColor,
  double? height,
}) {
  bool passwordVisible = isPassword;
  // final focusNode = FocusNode();

  return StatefulBuilder(builder: (context, newSetState) {
    // focusNode.addListener(() {
    //   if (focusNode.hasFocus) {
    //     hintText = "";
    //   } else {
    //     hintText = hintText;
    //   }
    //   newSetState(() {});
    // });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title, style: black16w500),
        if (title != null) heightBox(),
        SizedBox(
          height: height,
          child: TextFormField(
            scrollController: scrollController,
            maxLength: maxLength,

            // for scroll extra while keyboard open
            // scrollPadding: EdgeInsets.fromLTRB(20, 20, 20, 120),

            enabled: isEnabled != null && !isEnabled ? false : true,
            textAlign: align,
            readOnly: isReadOnly,
            showCursor: !isReadOnly,
            onTap: () {
              if (onTapFunction != null) {
                onTapFunction();
              }
            },
            key: key,
            focusNode: textFocusNode /*?? focusNode*/,
            onChanged: (value) {
              if (onChangedFunction != null) {
                onChangedFunction(value);
              }
            },
            onEditingComplete: () {
              if (onEditingComplete != null) {
                onEditingComplete();
              }
            },
            validator: (value) {
              return validationFunction != null ? validationFunction(value) : null;
            },
            // onSaved: onSavedFunction != null ? onSavedFunction : (value) {},
            onSaved: (value) {
              // ignore: void_checks
              return onSavedFunction != null ? onSavedFunction(value) : hideKeyBoard(context);
            },
            onFieldSubmitted: (value) {
              // ignore: void_checks
              return onFieldSubmit != null ? onFieldSubmit(value) : hideKeyBoard(context);
            },
            maxLines: maxLine ?? 1,
            keyboardType: keyboardType,
            controller: textEditingController,
            // initialValue: initialText,
            cursorColor: cursorColor ?? AppColors.black,
            obscureText: passwordVisible,
            textInputAction: inputAction,
            style: textStyle ?? black14w500,
            cursorWidth: 1,

            inputFormatters: inputFormatter,
            decoration: InputDecoration(
              errorStyle: red12w500.copyWith(color: AppColors.red),
              errorMaxLines: errorMaxLines ?? 1,
              filled: isFilled ?? true,
              fillColor: filledColor ?? AppColors.white.withOpacity(0.06),
              contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 20.0),
              border: underlineInputBorder ?? outlineInputBorder ?? outLineBorderStyle,
              focusedBorder: underlineInputBorder ?? outlineInputBorder ?? textFieldBorderStyle,
              disabledBorder: underlineInputBorder ?? outlineInputBorder ?? (isEnabled == false ? outLineBorderStyle : textFieldBorderStyle),
              enabledBorder: underlineInputBorder ?? outlineInputBorder ?? outLineBorderStyle,
              errorBorder: underlineInputBorder ?? outlineInputBorder ?? errorBorder,
              focusedErrorBorder: underlineInputBorder ?? outlineInputBorder ?? errorBorder,
              hintText: hintText,
              prefixIcon: preFixIcon,
              suffixIcon: showSuffixIcon == true
                  // ignore: prefer_if_null_operators
                  ? suffixIcon == null
                      ? isPassword
                          ? GestureDetector(
                              onTap: () {
                                newSetState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              child: passwordVisible
                                  ? Icon(
                                      CupertinoIcons.eye_slash,
                                      color: AppColors.grey,
                                    )
                                  : Icon(
                                      CupertinoIcons.eye,
                                      color: AppColors.grey,
                                    ))
                          : const SizedBox()
                      : suffixIcon
                  : const SizedBox(),
              hintStyle: hintStyle ?? grey14w500,
              label: label != null ? Text(label) : null,
              labelStyle: labelTextStyle,
            ),
          ),
        )
      ],
    );
  });
}
