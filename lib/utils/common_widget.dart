import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/modules/home_module/views/class_details_screen.dart';
import 'package:thia/modules/home_module/views/todo_details_screen.dart';
import 'package:thia/services/api_service_call.dart';
import 'package:thia/utils/common_stream_io.dart';
import 'package:thia/utils/utils.dart';

import '../modules/chat_module/views/stream_chat_page.dart';
import '../modules/home_module/model/calender_task_list_model.dart';
import '../modules/home_module/model/task_detail_model.dart';
import '../modules/home_module/views/add_todo_screen.dart';
import '../modules/home_module/views/calender_screen.dart';

showSnackBar({required String title, required String message, Color? backgroundColor}) {
  return Get.rawSnackbar(
    title: title,
    // title
    message: message,
    // message
    // overlayBlur: 1.25,
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor ??
        (title.isEmpty || title == ApiConfig.warning
            ? const Color(0xffFFCC00)
            : title == ApiConfig.success
                ? Colors.green
                : Colors.red),

    // colorText: title.isEmpty || title == ApiConfig.warning ? Colors.black : Colors.white,
    icon: Icon(
      title.isEmpty || title == ApiConfig.warning
          ? Icons.warning_amber_outlined
          : title == ApiConfig.success
              ? Icons.check_circle
              : Icons.error,
      color: title.isEmpty || title == ApiConfig.warning ? Colors.black : Colors.white,
    ),
    onTap: (_) {},
    shouldIconPulse: true,
    barBlur: 10,
    isDismissible: true,
    duration: Duration(seconds: (message.length > 20 ? 3 : 2)),
  );
}

Widget commonDialog({
  String? title,
  String? desc1,
  String? desc2,
  String? desc3,
  String? desc4,
  String? yesButtonName,
  String? noButtonName,
  Widget? child,
  VoidCallback? yesCallBack,
  VoidCallback? noCallBack,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Text(title ?? "", style: primary22w700, textAlign: TextAlign.center),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: desc1 ?? "", style: black16w500),
              TextSpan(text: desc2 ?? "", style: black16w700),
              TextSpan(text: desc3 ?? "", style: black16w500),
              TextSpan(text: desc4 ?? "", style: black16w700),
            ])),
        if (child != null) heightBox(height: 15),
        child ?? const SizedBox()
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: GetButton(
                  ontap: noCallBack ??
                      () {
                        Get.back();
                      },
                  height: 50.0,
                  borderRadius: 15,
                  backGroundColor: AppColors.grey,
                  text: noButtonName ?? "No",
                  textStyle: white18w600),
            ),
            widthBox(width: 15),
            Expanded(
              child: GetButton(
                  ontap: yesCallBack ??
                      () {
                        Get.back();
                      },
                  height: 50.0,
                  borderRadius: 15,
                  backGroundColor: AppColors.primaryColor,
                  text: yesButtonName ?? "Yes",
                  textStyle: white18w600),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget titleTextForField({String? text, TextStyle? style}) {
  return Text(text ?? "", style: style ?? black16w500);
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget heightBox({double height = 10}) {
  return SizedBox(height: height);
}

Widget widthBox({double width = 10}) {
  return SizedBox(width: width);
}

Widget customToolTip({String? text}) {
  return Tooltip(
    message: text ?? "",
    triggerMode: TooltipTriggerMode.tap,
    showDuration: const Duration(seconds: 30),
    child: Icon(Icons.help_outline, color: AppColors.primaryColor, size: 20),
  );
}

Widget getNetworkImage({
  double? height = 45.0,
  double? width = 45.0,
  double? borderRadius = 0,
  BorderRadiusGeometry? borderRadiusGeometry,
  bool? showCircularProgressIndicator = false,

  ///this is used when you don't want to give fix height and width to image (SUGGESTION:  fit: BoxFit.scaleDown for better UI)
  bool? isSizeNull,
  BoxFit? fit,
  BoxFit? errorFit,
  required String url,
}) {
  return ClipRRect(
    borderRadius: borderRadiusGeometry ?? BorderRadius.circular(borderRadius ?? 0),
    child: SizedBox(
      height: (isSizeNull ?? false) ? null : height,
      width: (isSizeNull ?? false) ? null : width,
      child: CachedNetworkImage(
        fit: fit ?? BoxFit.fill,
        imageUrl: url,
        placeholder: (context, url) {
          showCircularProgressIndicator ??= true;
          if (showCircularProgressIndicator == true) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  // color: const Color(0xff0C59EA).withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Platform.isAndroid ? const CircularProgressIndicator() : const CupertinoActivityIndicator(),
              ),
            );
          } else {
            return const Center(child: SizedBox());
          }
        },
        errorWidget: (context, url, error) {
          return Image.asset(
            ((height ?? 45) >= 100 || (width ?? 45.0) >= 100) ? Assets.imagesLogo : Assets.imagesLogo,
            fit: errorFit ?? (((height ?? 45) >= 100 || (width ?? 45.0) >= 100) ? BoxFit.contain : BoxFit.cover),
          );
        },
      ),
    ),
  );
}

Widget getTitleRow(String title, {String? endString}) {
  return Column(
    children: [
      const SizedBox(
        height: 20.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: black16w700,
          ),
          Text(
            endString ?? "",
            style: black16w700,
          )
        ],
      ),
      const SizedBox(
        height: 15.0,
      )
    ],
  );
}

Widget commonSearchTextField({required Function callBack, required TextEditingController controller}) {
  return TextFormField(
    maxLines: 1,
    keyboardType: TextInputType.text,
    controller: controller,
    cursorColor: AppColors.black,
    onChanged: (value) {
      callBack(value);
    },
    // initialValue: initialText,
    style: black14w400,
    decoration: InputDecoration(
      errorMaxLines: 1,
      filled: true,
      fillColor: AppColors.white,
      border: outLineBorderStyle,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
      focusedBorder: outLineBorderStyle,
      disabledBorder: outLineBorderStyle,
      enabledBorder: outLineBorderStyle,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      hintText: "Search",
      hintStyle: black14w400.copyWith(color: AppColors.black.withOpacity(0.50)),
      prefixIcon: Icon(Icons.search, color: AppColors.grey.withOpacity(0.6)),
    ),
  );
}

Widget noDataFoundWidget({String? message}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset(Assets.imagesNoDataFound, scale: 3.5),
        Lottie.asset(Assets.assetsNoDataFound, height: 175, repeat: false),
        heightBox(),
        Text(message ?? AppTexts.noDataFound, style: black24w700.copyWith(color: const Color(0xffa3a3eb))),
      ],
    ),
  );
}

Widget noInternetWidget({String? message, required Function() callBack}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Assets.iconsNoInternet, scale: 3.5),
        heightBox(),
        Text(message ?? AppTexts.noConnection, style: white24w700),
        heightBox(height: 40),
        GetButton(
          ontap: () async {
            if (await checkInternet()) {
              // kHomeController.isInternetAvailable.value = true;
              callBack();
            } else {
              // kHomeController.isInternetAvailable.value = false;
              showSnackBar(title: appName, message: "No Internet Available");
            }
          },
          text: AppTexts.tryAgain,
          width: 140.0,
          borderRadius: 40.0,
          backGroundColor: AppColors.white,
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.0), gradient: AppColors.linearGradient),
          textStyle: black16w500,
        ),
      ],
    ),
  );
}

Widget commonRadioTile({required String title, required RxString groupValue, Function? callBack, String? value}) {
  return Obx(() {
    return RadioListTile(
      visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
      title: Text(title),
      value: value ?? title,
      groupValue: groupValue.value,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      activeColor: AppColors.primaryColor,
      selectedTileColor: AppColors.primaryColor,
      onChanged: (value) {
        groupValue.value = value.toString();
        if (callBack != null) {
          callBack();
        }
      },
    );
  });
}

commonAlertDialog({
  String? title,
  String? message,
  String? yesText,
  String? noText,
  Function? okCall,
  Function? cancelCall,
  bool? showOkButton,
  bool? showCancelButton,
  double? titleFontSize,
}) async {
  if (!(Get.isDialogOpen ?? false)) {
    return Get.dialog(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 50.0),
                      Text(title ?? appName, style: primary16w600.copyWith(fontSize: titleFontSize ?? 28, decoration: TextDecoration.none)),
                      const SizedBox(height: 20.0),
                      Text(message ?? "", style: grey16w500.copyWith(height: 1.5, decoration: TextDecoration.none)).paddingSymmetric(horizontal: 10.0),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          if (showCancelButton ?? true)
                            Expanded(
                                child: GetButton(
                              text: noText ?? "No",
                              ontap: () {
                                if (cancelCall != null) {
                                  cancelCall();
                                }
                                Get.back();
                              },
                              isBorder: true,
                              backGroundColor: AppColors.grey,
                              textStyle: white18w600,
                            )),
                          const SizedBox(width: 10.0),
                          if (showOkButton ?? true)
                            Expanded(
                                child: GetButton(
                              text: yesText ?? "Yes",
                              textStyle: white18w600,
                              // fontColor: colorFFFFFF,
                              isBorder: false,
                              ontap: () {
                                Get.back();
                                if (okCall != null) {
                                  okCall();
                                }
                              },
                            )),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ).paddingSymmetric(horizontal: 20.0),
                ),
                Positioned(
                  top: -45,
                  right: 10,
                  left: 10,
                  child: Container(
                    height: 80,
                    width: 80,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                    ),
                    //TODO: uncomment below
                    // child: Image.asset(Assets.iconsBlueLogo, fit: BoxFit.scaleDown, color: AppColors.white, height: 75, width: 75),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}

Widget bottomNavigationBarItem({
  required IconData iconData,
  required Function() onTap,
  required String name,
  Color? iconColor,
  TextStyle? textStyle,
  bool? showRedDot,
}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Icon(
              iconData,
              color: iconColor ?? AppColors.primaryColor,
            ),
            if (showRedDot == true)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
        heightBox(height: 5),
        Text(
          name,
          style: textStyle ?? primary16w500,
        )
      ],
    ),
  );
}

Widget classRoomCard(BuildContext context, Course? data) {
  final image = kHomeController.getGroupPlaceHolder();
  return InkWell(
    onTap: () {
      Get.to(() => ClassDetailsScreen(data: data));
    },
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // color: AppColors.primaryColor.withOpacity(0.1),
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Row(
        children: [
          // Image.asset(Assets.imagesCardImage, scale: 3.5),
          Container(
            decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.6), borderRadius: BorderRadius.circular(50)),
            child: getNetworkImage(
              // url: "https://i.imgur.com/30L5oye.png",
              url: image,
              borderRadius: 50,
              height: 75,
              width: 75,
              fit: BoxFit.contain,
            ),
          ),
          widthBox(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data?.name ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: black18w600.copyWith(fontWeight: FontWeight.w700),
                ),
                // heightBox(height: 5),
                Divider(color: AppColors.primaryColor, thickness: 1.3),
                // heightBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data?.section ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: grey14w500,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        hideKeyBoard(context);
                        if (data?.teacherFolder == null) {
                          await chatButtonClick(
                            context,
                            name: data?.name ?? "",
                            id: data?.id ?? "",
                            image: image,
                            userIdList: [(kHomeController.userData.value.userId ?? "").toString()],
                          );
                        } else {
                          showSnackBar(title: ApiConfig.error, message: "Teachers are not allowed to chat with whole classroom.");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          color: data?.teacherFolder == null ? AppColors.primaryColor : AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> chatButtonClick(
  BuildContext context, {
  String? name,
  required String id,
  String? image,
  required List<String> userIdList,
  bool? removeRoute,
}) async {
  showProgressDialog();
  final client = StreamChat.of(context).client;
  // await StreamApi.watchChannel(client, type: "messaging", id: id).whenComplete(() async {
  await StreamApi.createChannel(
    client,
    type: "messaging",
    name: name,
    id: id,
    image: (image?.isEmpty ?? false) ? kHomeController.getGroupPlaceHolder() : image,
    // image: (image?.isEmpty ?? false) ? "https://www.pngkey.com/png/detail/950-9501315_katie-notopoulos-katienotopoulos-i-write-about-tech-user.png" : image,
    idMembers: userIdList,
  ).then(
    (channel) async {
      // await Future.delayed(const Duration(seconds: 1));
      await StreamApi.watchChannel(client, type: "messaging", id: id).then((value) async {
        return await Future.delayed(const Duration(seconds: 1)).then((value) {
          hideProgressDialog();
          if (removeRoute ?? false) {
            return Get.off(() => StreamChannel(channel: channel, child: ChannelPage(channel: channel)));
          } else {
            return Get.to(() => StreamChannel(channel: channel, child: ChannelPage(channel: channel)));
          }
        });
      });
      hideProgressDialog();
    },
  );
  // });
}

Widget assignmentCard({
  bool? showPlusButton,
  bool? showPriorityBar,
  bool? showDate = true,
  CourseWork? data,
  required Course subject,
}) {
  return Stack(
    fit: StackFit.loose,
    children: [
      Container(
        padding: const EdgeInsets.all(10).copyWith(top: (showPriorityBar ?? false) ? null : 0),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(15).copyWith(topLeft: const Radius.circular(10), topRight: const Radius.circular(10)),
        ),
        child: Column(
          children: [
            heightBox(),
            tile(
              title: "Name :",
              desc: data?.title ?? "",
              showPlusIcon: showPlusButton,
              data: TodoModel(
                classID: data?.courseId ?? "",
                name: data?.title ?? "",
                details: data?.description ?? "",
                duedate: DateTime.parse((DateTime(
                  data?.dueDate?.year ?? DateTime.now().year,
                  data?.dueDate?.month ?? DateTime.now().month,
                  data?.dueDate?.day ?? DateTime.now().day,
                )).toString())
                    .toString(),
                time: (("${data?.dueTime?.hours ?? 0}" ":" "${data?.dueTime?.minutes ?? 0}" ":" "${data?.dueTime?.seconds ?? 0}")).toString(),
              ),
              // subject: subject,
            ),
            if (showDate ?? false) heightBox(),
            if (showDate ?? false)
              tile(
                title: "Due :",
                desc: (data == null || data.dueDate == null) ? "NA" : (dateFormatter("${data.dueDate?.year}-${data.dueDate?.month}-${data.dueDate?.day}") ?? "").toString(),
                // subject: subject,
              ),
            heightBox(),
            tile(
              title: "Details :",
              desc: (data?.description) ?? "",
              // subject: subject,
            ),
            // heightBox(),
            // tile(title: "Estimated Time :", desc: data == null ? "3:00 Hour ⏳" : "${data.dueTime?.hours}:${data.dueTime?.minutes} hours ⏳"),
            // tile(
            //   title: "Estimated Time :",
            //   desc: (data == null || data.dueTime == null)
            //       ? "NA"
            //       : "${(printDuration(parseDuration((("${data.dueTime?.hours ?? 0}" ":" "${data.dueTime?.minutes ?? 0}" ":" "${data.dueTime?.seconds ?? 0}")).toString())))} ⏳",
            //   // : "${(timeFormatter(DateTime((data.dueDate?.year ?? 0), (data.dueDate?.month ?? 0), (data.dueDate?.day ?? 0), (data.dueTime?.hours ?? 0), (data.dueTime?.minutes ?? 0)).toString()))} ⏳",
            //   // subject: subject,
            // ),
          ],
        ),
      ),
      if (showPriorityBar ?? false)
        Container(
          height: 10,
          decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        ),
    ],
  );
}

Widget todoCard({
  bool? showPlusButton,
  // bool? showPriorityBar,
  bool? showDate = true,
  TodoModel? data,
  Function()? onTap,
  bool? showSubTask,
  TaskDetailModel? taskDetailModel,
  // required Course subject,
}) {
  return InkWell(
    onTap: onTap ??
        () {
          Get.to(() => TodoDetailsScreen(data: data ?? TodoModel()));
        },
    child: Stack(
      fit: StackFit.loose,
      children: [
        Container(
          padding: const EdgeInsets.all(10).copyWith(top: null),
          decoration: BoxDecoration(
            gradient: AppColors.purpleGradient,
            borderRadius: BorderRadius.circular(15).copyWith(topLeft: const Radius.circular(10), topRight: const Radius.circular(10)),
          ),
          child: Column(
            children: [
              heightBox(),
              tile(
                title: "Name :",
                desc: data?.name ?? "",
                showPlusIcon: showPlusButton,
                data: data,
                // subject: subject,
              ),
              if (showDate ?? false) heightBox(),
              if (showDate ?? false)
                tile(
                  title: "Due :",
                  desc: (data == null || data.duedate == null) ? "NA" : (dateFormatter(((DateTime.parse(data.duedate ?? "").toString()).toString()))),
                  // subject: subject,
                ),
              if (data?.details != null && data?.details?.isNotEmpty == true) heightBox(),
              if (data?.details != null && data?.details?.isNotEmpty == true)
                tile(
                  title: "Details :",
                  desc: (data?.details) ?? "",
                  // subject: subject,
                ),
              heightBox(),
              // tile(title: "Estimated Time :", desc: data == null ? "3:00 Hour ⏳" : "${data.dueTime?.hours}:${data.dueTime?.minutes} hours ⏳"),

              tile(
                title: "Estimated Time :",
                desc: data?.time == null ? "00 Hour ⏳" : "${(printDuration(parseDuration(data?.time ?? "")))} ⏳",
                // subject: subject,
              ),
              if (data?.createdBy != null)
                Column(
                  children: [
                    heightBox(),
                    tile(
                      title: "Created By :",
                      desc: data?.createdBy ?? "",
                      // subject: subject,
                    ),
                  ],
                ),

              if (showSubTask == true)
                StreamBuilder<Object>(
                    stream: kHomeController.taskDetailModel.stream,
                    builder: (context, snapshot) {
                      return kHomeController.taskDetailModel.value.data?.subTask?.isNotEmpty == true
                          ? Column(
                              children: [
                                heightBox(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: tile(
                                        title: "SubTasks ",
                                        desc: "",
                                        // subject: subject,
                                      ),
                                    ),
                                    Text(
                                      "Completed",
                                      style: white14w500,
                                    ),
                                  ],
                                ),
                                heightBox(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: kHomeController.taskDetailModel.value.data?.subTask?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Text(
                                            "\u2022  ",
                                            style: white16w600,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${kHomeController.taskDetailModel.value.data?.subTask?[index]?.name} ",
                                              style: white14w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24.0,
                                            width: 24.0,
                                            child: Checkbox(
                                                checkColor: AppColors.white,
                                                side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 1.5, color: Colors.white)),
                                                activeColor: Colors.transparent,
                                                value: kHomeController.taskDetailModel.value.data?.subTask?[index]?.iscomplete ?? false,
                                                onChanged: (val) {
                                                  // if (kHomeController.taskDetailModel.value.data?.subTask?[index]?.iscomplete != true) {
                                                  kHomeController.setSubTaskComplete(
                                                    kHomeController.taskDetailModel.value.data?.subTask?[index]?.subtaskid.toString() ?? "",
                                                    (val ?? false) ? 0 : 1,
                                                    () {
                                                      kHomeController.taskDetailModel.value.data?.subTask?[index]?.setComplete(val ?? false);
                                                      kHomeController.taskDetailModel.refresh();
                                                    },
                                                    showLoader: false,
                                                  );
                                                  // }
                                                }),
                                          )
                                        ],
                                      );
                                    })
                              ],
                            )
                          : const SizedBox();
                    }),

              if (data?.late == true) heightBox(),

              if (data?.late == true)
                tile(
                  title: "Over Due",
                  desc: "",
                  titleStyle: red12w500.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.yellow),
                ),
            ],
          ),
        ),
        // if (showPriorityBar ?? false)
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: data?.priority == 1
                ? AppColors.red
                : data?.priority == 2
                    ? AppColors.orange
                    : AppColors.yellow,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          ),
        ),
        if (data?.isCompleted ?? false)
          Positioned(
            top: 15,
            right: 15,
            child: Text(
              "Completed",
              style: white14w500.copyWith(color: Colors.greenAccent),
            ),
          ),
      ],
    ),
  );
}

Widget tile({
  required String title,
  required String desc,
  // required Course subject,
  bool? showPlusIcon,
  TodoModel? data,
  TextStyle? titleStyle,
  TextStyle? descStyle,
  TextStyle? moreStyle,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: titleStyle ?? white16w600),
      widthBox(),
      Expanded(
        child: ReadMoreText(
          desc,
          trimLines: 3,
          style: descStyle ?? white14w500,
          colorClickableText: Colors.greenAccent,
          trimMode: TrimMode.Line,
          moreStyle: moreStyle ?? white14w700.copyWith(fontWeight: FontWeight.w800),
          lessStyle: moreStyle ?? white14w700.copyWith(fontWeight: FontWeight.w800),
          trimCollapsedText: 'Show more',
          trimExpandedText: ' Show less',
        ),
      ),
      if (showPlusIcon ?? false)
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Get.to(() => AddTodoScreen(
                    data: data,
                    fromBottomBar: false,
                    // subject: subject,
                  ));
            },
            child: Icon(
              Icons.add_circle_outline_sharp,
              color: AppColors.white,
              size: 24,
            ),
          ),
        ),
    ],
  );
}

Widget commonBottomBar(BuildContext context, bool isFromDetails, {Course? subject, int? index}) {
  StreamChatClient client = StreamChat.of(context).client;

  // getUnreadMessage(context);
  RxInt count = 0.obs;
  client.on().where((Event event) {
    return event.unreadChannels != null;
  }).listen((Event event) {
    count.value = event.unreadChannels ?? 0;
    showLog("Unread channels count changed to:${event.unreadChannels}");
    showLog("Unread messages count changed to:${event.totalUnreadCount}");
  });

  return Container(
    height: 75.0,
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1.5, blurRadius: 1)],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder<Object>(
            stream: count.stream,
            builder: (context, snapshot) {
              return bottomNavigationBarItem(
                  iconData: Icons.chat_bubble_outline,
                  name: AppTexts.chat,
                  showRedDot: count.value > 0 ? true : false,
                  iconColor: subject?.teacherFolder == null ? AppColors.primaryColor : AppColors.grey,
                  textStyle: primary16w500.copyWith(color: subject?.teacherFolder == null ? AppColors.primaryColor : AppColors.grey),
                  onTap: () async {
                    if (index != 1) {
                      if (subject?.teacherFolder == null) {
                        final client = StreamChat.of(context).client;

                        if (isFromDetails) {
                          await chatButtonClick(
                            context,
                            name: subject?.name ?? "",
                            id: subject?.id ?? "",
                            image: "",
                            userIdList: [(kHomeController.userData.value.userId ?? "").toString()],
                          );
                        } else {
                          Get.to(() => StreamChat(client: client, child: const ChannelListPage()));
                        }
                      } else {
                        showSnackBar(title: ApiConfig.error, message: "Teachers are not allowed to chat with whole classroom.");
                      }
                    }
                  });
            }),
        bottomNavigationBarItem(
            iconData: CupertinoIcons.add,
            name: AppTexts.addTodo,
            onTap: () {
              Get.to(() => AddTodoScreen(fromBottomBar: !isFromDetails, subject: subject));
            }),
        bottomNavigationBarItem(
            iconData: CupertinoIcons.calendar,
            name: AppTexts.calendar,
            onTap: () {
              if (index != 3) {
                Get.to(() => const CalenderScreen());
              }
            }),
      ],
    ),
  );
}

void getUnreadMessage(BuildContext context) async {
  StreamChatClient client = StreamChat.of(context).client;

  final response = await client.channel("messaging").watch();
  showLog("length ===> ${response.read?.length}");
  // showLog("There are ${response.me.unreadChannels} unread channels");
  // showLog("There are ${response.me.totalUnreadCount} unread messages");
}
