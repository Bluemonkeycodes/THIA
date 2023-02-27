import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/main.dart';
import 'package:thia/modules/home_module/views/all_todo_screen.dart';
import 'package:thia/modules/profile_module/views/profile_screen.dart';
import 'package:thia/utils/common_stream_io.dart';
import 'package:thia/utils/social_login.dart';

import '../../../utils/utils.dart';
import '../../auth/model/login_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  initUser() async {
    kHomeController.classListLoading.value = true;
    await StreamApi.initUser(
      StreamChat.of(context).client,
      username: "${kHomeController.userData.value.firstname ?? ""} ${kHomeController.userData.value.lastname ?? ""}",
      urlImage: kHomeController.userData.value.profileUrl ?? "",
      id: (kHomeController.userData.value.userId ?? "").toString(),
      token: getPreference.read(PrefConstants.loginToken) ?? "",
    );
    await refreshToken(() {});
    await kHomeController.getClassList();
    await kHomeController.getPriorityCount(showLoader: false);
    kHomeController.classListLoading.value = false;
  }

  @override
  void initState() {
    super.initState();
    kHomeController.userData.value = LoginModelDataData.fromJson(getObject(PrefConstants.userDetails));
    initUser();
  }

  @override
  Widget build(BuildContext context) {
    showLog(getPreference.read(PrefConstants.loginToken));
    return Scaffold(
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
                color: AppColors.buttonColor,
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
            List<Course>? x = kHomeController.courseModel.value.courses?.where((element) => element.courseState == "ACTIVE").toList();
            // List<Course>? x = kHomeController.courseModel.value.courses;
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
