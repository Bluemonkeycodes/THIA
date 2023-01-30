import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/modules/home_module/views/class_details_screen.dart';
import 'package:thia/services/api_service_call.dart';
import 'package:thia/utils/common_stream_io.dart';
import 'package:thia/utils/utils.dart';

import '../modules/chat_module/views/stream_chat_page.dart';
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
    title: Text(title ?? "", style: blue22w700, textAlign: TextAlign.center),
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
                  backGroundColor: AppColors.buttonColor,
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
    child: const Icon(Icons.help_outline, color: AppColors.buttonColor, size: 20),
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
            ((height ?? 45) >= 100 || (width ?? 45.0) >= 100) ? Assets.imagesAppLogo : Assets.imagesAppLogo,
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
        Image.asset(Assets.imagesNoDataFound, scale: 3.5),
        heightBox(),
        Text(message ?? AppTexts.noDataFound, style: white24w700),
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
      activeColor: AppColors.buttonColor,
      selectedTileColor: AppColors.buttonColor,
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
                      Text(title ?? appName, style: blue16w600.copyWith(fontSize: titleFontSize ?? 28, decoration: TextDecoration.none)),
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
                      color: AppColors.buttonColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.color2697FF.withOpacity(0.2)),
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

Widget bottomNavigationBarItem({required IconData iconData, required Function() onTap, required String name}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: AppColors.borderColor,
        ),
        heightBox(height: 5),
        Text(name, style: blue16w500)
      ],
    ),
  );
}

Widget classRoomCard(BuildContext context) {
  return InkWell(
    onTap: () {
      Get.to(() => const ClassDetailsScreen());
    },
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.borderColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Image.asset(Assets.imagesCardImage, scale: 3.5),
          widthBox(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: black18w600.copyWith(fontWeight: FontWeight.w700),
                ),
                heightBox(),
                const Divider(color: AppColors.borderColor, thickness: 1.3),
                heightBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTexts.johnDeo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: grey14w500,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // hideKeyBoard(context);

                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) {
                        //     return StreamChannel(channel: channel, child: ChannelPage(channel: channel));
                        //   },
                        // ));
                        /*  final client = StreamChat.of(context).client;

                        // await client.connectUser(User(id: StreamConfig.idPeter), StreamConfig.tokenPeter);

                        String name = "xyz";
                        String classId = "xyz";
                        List<String> userList = ["id1", "id-1", "id2"];
                        Channel channel = await StreamApi.createChannel(
                          client,
                          type: "messaging",
                          name: name,
                          id: classId,
                          image:
                              "https://images.unsplash.com/photo-1506869640319-fe1a24fd76dc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Z3JvdXB8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60",
                          idMembers: userList,
                        );

                        await StreamApi.watchChannel(client, type: "messaging", id: classId);
                        Get.to(() => StreamChannel(channel: channel, child: ChannelPage(channel: channel)));*/
                        await chatButtonClick(
                          context,
                          name: "xyz",
                          id: "xyz",
                          image: "",
                          userIdList: ["id1", "id-1", "id2"],
                          isGroup: true,
                        );
                      },
                      child: const Icon(Icons.chat_bubble_outline, color: AppColors.borderColor),
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
  required String name,
  required String id,
  required String image,
  required List<String> userIdList,
  required bool isGroup,
}) async {
  final client = StreamChat.of(context).client;
  Channel channel = await StreamApi.createChannel(
    client,
    type: "messaging",
    name: name,
    id: id,
    image: image.isEmpty ? "https://www.pngkey.com/png/detail/950-9501315_katie-notopoulos-katienotopoulos-i-write-about-tech-user.png" : image,
    idMembers: userIdList,
  );

  await StreamApi.watchChannel(client, type: "messaging", id: id);
  Get.to(() => StreamChannel(channel: channel, child: ChannelPage(channel: channel)));
}

Widget todoSection({
  bool? showPlusButton,
  bool? showDate = true,
}) {
  return Stack(
    fit: StackFit.loose,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(15).copyWith(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            heightBox(),
            tile(title: "Name :", desc: "John Deo", showPlusIcon: showPlusButton),
            if (showDate ?? false) heightBox(),
            if (showDate ?? false) tile(title: "Due :", desc: "30 March 2022"),
            heightBox(),
            tile(
                title: "Details :",
                desc:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley."),
            heightBox(),
            tile(title: "Estimated Time :", desc: "3:00 Hour ⏳"),
          ],
        ),
      ),
      Container(
        height: 10,
        decoration: const BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      ),
    ],
  );
}

Widget tile({required String title, required String desc, bool? showPlusIcon}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: white16w600,
      ),
      widthBox(),
      Expanded(
        child: ReadMoreText(
          desc,
          trimLines: 3,
          style: white14w500,
          colorClickableText: Colors.greenAccent,
          trimMode: TrimMode.Line,
          moreStyle: white14w700.copyWith(fontWeight: FontWeight.w800),
          lessStyle: white14w700.copyWith(fontWeight: FontWeight.w800),
          trimCollapsedText: 'Show more',
          trimExpandedText: ' Show less',
        ),
      ),
      if (showPlusIcon ?? false)
        const Align(
          alignment: Alignment.topRight,
          child: Icon(
            Icons.add_circle_outline_sharp,
            color: AppColors.white,
            size: 20,
          ),
        ),
    ],
  );
}

Widget commonBottomBar(BuildContext context, bool isFromDetails) {
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
        bottomNavigationBarItem(
            iconData: Icons.chat_bubble_outline,
            name: AppTexts.chat,
            onTap: () async {
              final client = StreamChat.of(context).client;

              String name = "name-1";
              String userId = "id1";
              String otherUserId = "id-1";
              await StreamApi.createChannel(
                client,
                type: "messaging",
                name: "$userId-$otherUserId",
                id: "$userId-$otherUserId",
                image: "https://png.pngtree.com/png-vector/20190710/ourmid/pngtree-user-vector-avatar-png-image_1541962.jpg",
                idMembers: [userId, otherUserId],
              );

              await StreamApi.watchChannel(client, type: "messaging", id: "$userId-$otherUserId");
              if (isFromDetails) {
                await chatButtonClick(
                  context,
                  name: "xyz",
                  id: "xyz",
                  image: "",
                  userIdList: ["id1", "id-1", "id2"],
                  isGroup: true,
                );
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return StreamChat(client: client, child: const ChannelListPage());
                  },
                ));
              }
            }),
        bottomNavigationBarItem(
            iconData: CupertinoIcons.add,
            name: AppTexts.addTodo,
            onTap: () {
              Get.to(() => const AddTodoScreen());
            }),
        bottomNavigationBarItem(
            iconData: CupertinoIcons.calendar,
            name: AppTexts.calendar,
            onTap: () {
              Get.to(() => const CalenderScreen());
            }),
      ],
    ),
  );
}
