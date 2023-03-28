import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thia/utils/utils.dart';

Widget getDeleteDialog({required Function() ontapYes, required Function() ontapNo}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 20.0),
      Text("Are you sure you want to delete?", style: black14w700),
      const SizedBox(height: 30.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetButton(ontap: ontapYes, width: 136.0, height: 47.0, isBorder: false, text: "Yes", textStyle: white16w700, backGroundColor: AppColors.primaryColor),
          const SizedBox(width: 15.0),
          GetButton(ontap: ontapNo, width: 136.0, height: 47.0, isBorder: false, text: "No", textStyle: white16w700, backGroundColor: AppColors.primaryColor),
        ],
      ),
      const SizedBox(height: 20.0),
    ],
  );
}
