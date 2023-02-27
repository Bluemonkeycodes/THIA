import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thia/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

// Future<void> onShare(BuildContext context, {required title, subject}) async {
//   final box = context.findRenderObject() as RenderBox?;
//
//   await Share.share(
//     title,
//     subject: subject,
//     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
//   );
// }

setIsLogin({required bool isLogin}) {
  getPreference.write(PrefConstants.isLogin, isLogin);
}

bool getIsLogin() {
  return (getPreference.read(PrefConstants.isLogin) ?? false);
}

bool getIsGuest() {
  return (getPreference.read(PrefConstants.isGuest) ?? false);
}

getFcmToken() {
  return getPreference.read(PrefConstants.fcmTokenPref) ?? "";
}

setFcmToken(String value) {
  getPreference.write(PrefConstants.fcmTokenPref, value);
}

hideKeyBoard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

isNotEmptyString(String? string) {
  return string != null && string.isNotEmpty;
}

getObject(String key) {
  return getPreference.read(key) != null ? json.decode(getPreference.read(key)) : null;
}

setObject(String key, value) {
  getPreference.write(key, json.encode(value));
}

showLog(text) {
  if (kDebugMode) {
    log((text ?? "").toString());
  }
}

readStringDataFromPref(String key) {
  return getPreference.read(key);
}

///to check if string is empty or null
//use it like string.checkIsNotEmptyOrNull
// it will return bool

extension IsNotEmpty on String? {
  bool get isNotEmptyOrNull {
    return this != null && (this?.trim().isNotEmpty ?? false);
  }
}

launchURL(String url, {bool forceWeb = false}) async {
  if (await canLaunch(url)) {
    await launch(url, universalLinksOnly: forceWeb, forceWebView: forceWeb, forceSafariVC: forceWeb);
  } else {
    showSnackBar(message: "could not launch $url", title: ApiConfig.error);
    // throw 'Could not launch $url';
  }
}

passwordValidation(String value, {bool? isConfirm, String? oldValue}) {
  return value.toString().isEmpty
      ? "Please Enter Password."
      : value.toString().length < 6
          ? "Password length must be 6 characters."
          : isConfirm ?? false
              ? oldValue == value
                  ? null
                  : "Both new Password must be same."
              : null;
}

dateFormatter(String? dateTime, {String? dateFormat}) {
  final DateTime now = DateTime.now();
  DateFormat formatter = DateFormat(dateFormat ?? 'dd MMM yyyy');
  final String formatted;
  if (isNotEmptyString(dateTime)) {
    // 'yyyy-MM-dd'
    formatted = formatter.format(DateFormat('yyyy-MM-dd').parse(dateTime!).toLocal());
  } else {
    formatted = formatter.format(now);
  }
  return formatted;
}

timeFormatter(String? dateTime, {String? dateFormat}) {
  final DateTime now = DateTime.now();
  DateFormat formatter = DateFormat(dateFormat ?? "hh:mm a");
  final String formatted;
  if (isNotEmptyString(dateTime)) {
    formatted = formatter.format(DateTime.parse(dateTime!).toLocal());
  } else {
    formatted = formatter.format(now.toLocal());
  }
  return formatted;
}

String printDuration(Duration duration) {
  ///if duration is in String then parse String in "parseDuration" function which is below this.
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  // String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  return "${twoDigits(duration.inHours)} hours $twoDigitMinutes min.";
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

String shortNumberGenerator(num num) {
  return NumberFormat.compactSimpleCurrency().format(num);
  // if (num > 0) {
  //   if (num > 999 && num < 99999) {
  //     return "\$${(num / 1000).toStringAsFixed(1)}K";
  //   } else if (num > 99999 && num < 999999) {
  //     return "\$${(num / 1000).toStringAsFixed(0)}K";
  //   } else if (num > 999999 && num < 999999999) {
  //     return "\$${(num / 1000000).toStringAsFixed(1)}M";
  //   } else if (num > 999999999 && num < 999999999999) {
  //     return "\$${(num / 1000000000).toStringAsFixed(1)}B";
  //   } else if (num > 999999999999) {
  //     return "\$${(num / 1000000000000).toStringAsFixed(1)}T";
  //   } else {
  //     return "\$${num.toStringAsFixed(1)}";
  //   }
  // } else {
  //   return "\$0";
  // }
}

bool isURL(String s) => hasMatch(s, r"[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?");

bool isZipValid(String s) => RegExp(r"^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$", caseSensitive: false).hasMatch(s);

bool hasMatch(String? value, String pattern) {
  return (value == null) ? false : RegExp(pattern).hasMatch(value);
}

bool isPercentage(String s) => hasMatch(s, r"(^100(\.0{1,2})?$)|(^([1-9]([0-9])?|0)(\.[0-9]{1,2})?$)");

percentageValidation(String value) {
  return value.toString().isEmpty
      ? "Please Enter percentage value."
      : value.toString().length > 5
          ? "Percentage maximum length must be less then 4"
          : !isPercentage(value)
              ? "Please enter valid percentage value."
              : null;
}

emailOrPhoneValidation(String data) {
  if (data.toString().isEmpty) {
    return "Please Enter Email or Phone number.";
  } else if (data.toString().isNumericOnly) {
    if (!GetUtils.isPhoneNumber(data)) {
      return "Enter Valid Phone number.";
    } else if (data.toString().length != 10) {
      return "Enter Valid Phone number.";
    } else {
      return null;
    }
  } else {
    if (!GetUtils.isEmail(data)) {
      return "Enter Valid Email.";
    } else {
      return null;
    }
  }
}

String differenceAgo(DateTime dateTime) {
  return dateTime.day == DateTime.now().day ? convertToAgo(dateTime) : DateFormat("dd MMMM yy").format(dateTime);
}

String convertToAgo(DateTime input) {
  Duration diff = DateTime.now().difference(input);

  if (diff.inHours >= 1) {
    return diff.inHours > 1 ? '${diff.inHours} hour ago' : '${diff.inHours} hours ago';
  } else if (diff.inMinutes >= 1) {
    return diff.inMinutes > 1 ? '${diff.inMinutes} minute ago' : '${diff.inMinutes} minutes ago';
  } else if (diff.inSeconds >= 1) {
    return diff.inSeconds > 1 ? '${diff.inSeconds} second ago' : '${diff.inSeconds} seconds ago';
  } else {
    return 'just now';
  }
}

String currencyFormatter(String amount, {String? symbol, String? emptyStringPlaceHolder}) {
  if (amount == '-' || amount.trim() == 'null' || amount == '') {
    return emptyStringPlaceHolder ?? 'N/A';
  } else {
    return NumberFormat.currency(name: symbol ?? "\$", decimalDigits: 0).format(double.parse(amount));
  }
}

emptyFieldValidation(value) {
  return value.toString().isEmpty ? notEmptyFieldMessage : null;
}

String formNum(TextEditingController controller) {
  if (controller.text.isNotEmpty) {
    showLog("s ===> ${controller.selection.base.offset}");

    int position = controller.selection.base.offset;
    showLog("NumberFormat.currency ===> ${NumberFormat().format(double.parse(controller.text.replaceAll(",", "")))}");
    controller.text = NumberFormat().format(double.parse(controller.text.replaceAll(",", "")));
    int specialCharLength = 0;
    if (controller.text.contains(",")) {
      specialCharLength = controller.text.split(",").length - 1;
    }

    showLog("xxx ===> ${controller.text.split(",").length - 1}");
    showLog("position ===> $position");
    // controller.selection = TextSelection.fromPosition(TextPosition(offset: position + specialCharLength));
    controller.selection = TextSelection.fromPosition(TextPosition(offset: position));
    showLog("controller.selection ===> ${controller.selection}");
  }
  return controller.text;
}

final priceFormatterList = <TextInputFormatter>[
  FilteringTextInputFormatter.deny("."),
  FilteringTextInputFormatter.deny("-"),
  FilteringTextInputFormatter.deny(" "),
  PriceInputFormatter(),
  LengthLimitingTextInputFormatter(11),
];

class PriceInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) && oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex = newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}

String getGoogleMapImage(double lat, double long) {
  return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,%20$long&zoom=12&size=512x250&markers=size:mid%7Ccolor:red%7C$lat,%20$long&key=${PrefConstants.googleApiKey}";
}

void shareLatLongUrl({required double lat, required double long}) async {
  String url = "https://www.google.com/maps/search/?api=1&query=$lat,$long";
  showLog("shareLatLongUrl ===> $url");
  launchURL(url);
}

String getAddressLine(String floorNo, String address) {
  return "${(floorNo.isEmpty) ? "" : "$floorNo, "}$address";
}

String calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = math.cos;
  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return (12742 * math.asin(math.sqrt(a)) * 0.621371).toStringAsFixed(2);
}

DateTime? exitBackPressTime;
DateTime? currentBackPressTime;

// Future<bool> onWillPop() {
//   if (kMainController.selectedBottomIndex.value != 0) {
//     kMainController.selectedBottomIndex.value = 0;
//     return Future.value(false);
//   } else {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       showSnackBar(message: "Back again to Exit!", title: appName, backgroundColor: AppColors.black);
//       // Fluttertoast.showToast(msg: 'Back again to Exit!');
//       return Future.value(false);
//     }
//   }
//   return Future.value(true);
// }
