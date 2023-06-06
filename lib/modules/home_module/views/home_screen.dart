import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/main.dart';
import 'package:thia/modules/home_module/views/all_todo_screen.dart';
import 'package:thia/modules/profile_module/views/profile_screen.dart';
import 'package:thia/utils/common_stream_io.dart';
import 'package:thia/utils/social_login.dart';
import 'package:upgrader/upgrader.dart';

import '../../../utils/firebase_messaging_service.dart';
import '../../../utils/utils.dart';
import '../../auth/model/login_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.name, this.id, this.image}) : super(key: key);
  final String? name;
  final String? id;
  final String? image;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  initUser(context) async {
    getStreamContext(context);
    kHomeController.classListLoading.value = true;
    try {
      // StreamChat.of(context).client.disconnectUser();
      await StreamApi.initUser(
        StreamChat.of(context).client,
        username: "${kHomeController.userData.value.firstname ?? ""} ${kHomeController.userData.value.lastname ?? ""}",
        urlImage: kHomeController.userData.value.profileUrl ?? "",
        id: (kHomeController.userData.value.userId ?? "").toString(),
        token: getPreference.read(PrefConstants.loginToken) ?? "",
      );
      if (widget.id != null) {
        // widget.callBack!();
        kHomeController.classListLoading.value = false;
        await chatButtonClick(
          context,
          name: widget.name,
          id: widget.id ?? "",
          image: widget.image,
          userIdList: [(kHomeController.userData.value.userId ?? "").toString()],
        );
      }
      registerDevice(context);
      await FirebaseNotificationService(context1: context).initializeService(context);
      await refreshToken(() {});
      await kHomeController.getPriorityCount(showLoader: false);
      await kHomeController.getClassList();
      kHomeController.classListLoading.value = false;
    } catch (e) {
      kHomeController.classListLoading.value = false;
      showLog("e ===> $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      kHomeController.userData.value = LoginModelDataData.fromJson(getObject(PrefConstants.userDetails));
      initUser(context);
    });
  }

  registerDevice(BuildContext context) {
    // StreamChatClient client = StreamChat.of(context).client;
    StreamChat.of(context).client.addDevice(getFcmToken() ?? "", PushProvider.firebase, pushProviderName: "firebase");
    FirebaseNotificationService.firebaseMessaging.onTokenRefresh.listen((token) {
      // FirebaseNotificationService.firebaseMessaging.getToken().then((token) {
      StreamChat.of(context).client.addDevice(token, PushProvider.firebase, pushProviderName: "firebase");
    });
  }

  @override
  Widget build(BuildContext context) {
    showLog("FCM token ===> ${getFcmToken() ?? " "}");
    showLog("token ===> ${getPreference.read(PrefConstants.loginToken) ?? " "}");
    return UpgradeAlert(
      upgrader: Upgrader(
        // minAppVersion: ,
        // debugDisplayAlways: true,
        dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0, top: 40),
          child: Column(
            children: [
              topSection(),
              heightBox(height: 30),
              prioritySection(),
              heightBox(),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    kHomeController.classListLoading.value = true;
                    await kHomeController.getPriorityCount(showLoader: false);
                    await kHomeController.getClassList();
                    kHomeController.classListLoading.value = false;
                  },
                  child: StreamBuilder<Object>(
                      stream: kHomeController.classListLoading.stream,
                      builder: (context, snapshot) {
                        return kHomeController.classListLoading.value ? const Center(child: CircularProgressIndicator()) : cardSection();
                      }),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: commonBottomBar(context, false),
      ),
    );
  }

  Widget cardSection() {
    return StreamBuilder<Object>(
        stream: kHomeController.courseModel.stream,
        builder: (context, snapshot) {
          if (kHomeController.courseModel.value.courses?.isEmpty ?? true) {
            return ListView(
              shrinkWrap: true,
              children: [
                heightBox(height: getScreenHeight(context) / 10),
                noDataFoundWidget(message: AppTexts.noClass),
              ],
            );
          } else {
            // List<Course>? x = kHomeController.courseModel.value.courses?.where((element) => element.courseState == "ACTIVE").toList();
            List<Course>? x = kHomeController.courseModel.value.courses;
            return ListView.separated(
              itemCount: x?.length ?? 0,
              shrinkWrap: true,
              // primary: false,
              padding: const EdgeInsets.only(bottom: 10),
              separatorBuilder: (context, index) {
                return heightBox(height: 25);
              },
              itemBuilder: (context, index) {
                return classRoomCard(context, x?[index]);
              },
            );
          }
        });
  }

  Widget prioritySection() {
    return StreamBuilder<Object>(
        stream: kHomeController.getPriorityCountModel.stream,
        builder: (context, snapshot) {
          return Row(
            children: [
              Expanded(
                  child: priorityTab(
                color: AppColors.red,
                data: "${kHomeController.getPriorityCountModel.value.data?.high ?? 0}",
                priority: AppTexts.high,
                selectedCount: 1,
              )),
              Expanded(
                  child: priorityTab(
                color: AppColors.orange,
                data: "${kHomeController.getPriorityCountModel.value.data?.medium ?? 0}",
                priority: AppTexts.mid,
                selectedCount: 2,
              )),
              Expanded(
                  child: priorityTab(
                color: AppColors.yellow,
                data: "${kHomeController.getPriorityCountModel.value.data?.low ?? 0}",
                priority: AppTexts.low,
                selectedCount: 3,
              )),
            ],
          );
        });
  }

  Widget priorityTab({
    required Color color,
    required String data,
    required String priority,
    required int selectedCount,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            Get.to(() => AllTodoScreen(selectedCount: selectedCount));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
            child: Text(data, style: white18w700),
          ),
        ),
        heightBox(),
        Text("$priority Priority", style: black16w500),
      ],
    );
  }

  Widget topSection() {
    return StreamBuilder<Object>(
        stream: kHomeController.userData.stream,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appName, style: grey14w700),
                    heightBox(),
                    Text("${kHomeController.userData.value.firstname ?? ""} ${kHomeController.userData.value.lastname ?? ""}", style: black24w700),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const ProfileScreen());
                },
                child: getNetworkImage(
                  url: kHomeController.userData.value.profileUrl ?? "",
                  height: 40,
                  width: 40,
                  borderRadius: 10,
                ),
              ),
            ],
          );
        });
  }
}
