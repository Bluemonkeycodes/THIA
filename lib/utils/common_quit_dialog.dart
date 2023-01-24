// import 'package:delpick/utils/font_styles.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:delpick/utils/colors.dart';
// import 'package:delpick/utils/common_button.dart';

// Widget getDeleteDialog(
//     {required Function() ontapYes, required Function() ontapNo}) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       const SizedBox(
//         height: 40.0,
//       ),
//       Text(
//         "Are you sure you want to delete?",
//         style: blackPoppins14w700,
//       ),
//       const SizedBox(
//         height: 30.0,
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           GetButton(
//             ontap: ontapYes,
//             width: 136.0,
//             height: 47.0,
//             isBorder: true,
//             border: Border.all(
//               color: AppColors.primaryColor,
//             ),
//             text: "yes",
//             textStyle: primaryPoppins16w700.copyWith(color: AppColors.red),
//             backGroundColor: AppColors.white,
//           ),
//           const SizedBox(
//             width: 10.0,
//           ),
//           GetButton(
//               ontap: ontapNo,
//               width: 136.0,
//               height: 47.0,
//               isBorder: false,
//               text: "No",
//               textStyle: whitePoppins16w700,
//               backGroundColor: AppColors.darkBlueColor),
//         ],
//       ),
//       const SizedBox(
//         height: 40.0,
//       ),
//     ],
//   );
// }
