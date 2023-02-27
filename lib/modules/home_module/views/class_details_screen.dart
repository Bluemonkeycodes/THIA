import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/utils/utils.dart';

import '../model/class_user_model.dart';

class ClassDetailsScreen extends StatefulWidget {
  const ClassDetailsScreen({Key? key, this.data}) : super(key: key);
  final Course? data;

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    kHomeController.selectedTabIndex.value = 1;
    _tabController = TabController(length: 2, vsync: this);
    kHomeController.userTodoList.clear();
    kHomeController.courseWorkList.clear();
    kHomeController.selectedPeopleTabIndex.value = 0;

    // kHomeController.getAllAssignmentList(widget.data?.id ?? "");
    kHomeController.getClassTaskList(classID: widget.data?.id ?? "", showProgress: false);
  }

  @override
  Widget build(BuildContext context) {
    widget.data?.id;
    return Scaffold(
      appBar: GetAppBar(context, widget.data?.name ?? ""),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20).copyWith(bottom: 10),
            child: Column(
              children: [
                topSection(),
                heightBox(height: 15),
                Expanded(child: mainSection()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: commonBottomBar(
        context,
        true,
        subject: widget.data,
      ),
    );
  }

  Widget mainSection() {
    return StreamBuilder<Object>(
        stream: kHomeController.courseWorkList.stream,
        builder: (context, snapshot) {
          return StreamBuilder<Object>(
              stream: kHomeController.selectedTabIndex.stream,
              builder: (context, snapshot) {
                return kHomeController.selectedTabIndex.value == 3
                    ? Column(
                        children: [
                          heightBox(),
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.borderColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              onTap: (index) {
                                kHomeController.selectedPeopleTabIndex.value = index;
                              },
                              // give the indicator a decoration (color and border radius)
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: AppColors.borderColor,
                              ),
                              labelColor: Colors.white,
                              labelStyle: white18w500,
                              unselectedLabelColor: Colors.black,
                              tabs: const [Tab(text: 'Peoples'), Tab(text: 'Todos')],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          StreamBuilder<Object>(
                              stream: kHomeController.selectedPeopleTabIndex.stream,
                              builder: (context, snapshot) {
                                return kHomeController.selectedPeopleTabIndex.value == 0
                                    ? Expanded(
                                        child: StreamBuilder<Object>(
                                            stream: kHomeController.classUserList.stream,
                                            builder: (context, snapshot) {
                                              return kHomeController.classUserList.isEmpty
                                                  ? (kHomeController.classUserProgress.value)
                                                      ? const Center(child: CircularProgressIndicator())
                                                      : noDataFoundWidget(message: AppTexts.noUser)
                                                  : ListView.separated(
                                                      itemCount: kHomeController.classUserList.length,
                                                      separatorBuilder: (context, index) {
                                                        return Divider(endIndent: 10, indent: 10, color: AppColors.black.withOpacity(0.35));
                                                      },
                                                      itemBuilder: (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            hideKeyBoard(context);
                                                            // Get.to(() => const MessagesScreen());
                                                          },
                                                          child: userTile(kHomeController.classUserList[index]),
                                                        );
                                                      },
                                                    );
                                            }),
                                      )
                                    : Expanded(
                                        child: StreamBuilder<Object>(
                                            stream: kHomeController.otherUserTaskList.stream,
                                            builder: (context, snapshot) {
                                              return StreamBuilder<Object>(
                                                  stream: kHomeController.otherUserProgress.stream,
                                                  builder: (context, snapshot) {
                                                    return kHomeController.otherUserTaskList.isEmpty
                                                        ? (kHomeController.otherUserProgress.value)
                                                            ? const Center(child: CircularProgressIndicator())
                                                            : noDataFoundWidget(message: AppTexts.noTodoFound)
                                                        : ListView.separated(
                                                            itemCount: kHomeController.otherUserTaskList.length,
                                                            itemBuilder: (context, index) {
                                                              return kHomeController.otherUserTaskList.isEmpty
                                                                  ? noDataFoundWidget(message: AppTexts.noTodoFound)
                                                                  : todoCard(
                                                                      showPlusButton: true,
                                                                      data: kHomeController.otherUserTaskList[index],
                                                                      // subject: widget.data ?? Course(),
                                                                    );
                                                            },
                                                            separatorBuilder: (context, index) {
                                                              return heightBox(height: 12);
                                                            },
                                                          );
                                                  });
                                            }));
                              })
                        ],
                      )
                    : (kHomeController.selectedTabIndex.value == 2)
                        ? StreamBuilder<Object>(
                            stream: kHomeController.courseLoading.stream,
                            builder: (context, snapshot) {
                              return (kHomeController.courseWorkList.isNotEmpty)
                                  ? ListView.separated(
                                      itemCount: kHomeController.selectedTabIndex.value == 2 ? (kHomeController.courseWorkList.length) : 10,
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return heightBox(height: 12);
                                      },
                                      itemBuilder: (context, index) {
                                        return StreamBuilder<Object>(
                                            stream: kHomeController.selectedTabIndex.stream,
                                            builder: (context, snapshot) {
                                              return assignmentCard(
                                                showPlusButton: kHomeController.selectedTabIndex.value != 1 ? true : false,
                                                showPriorityBar: kHomeController.selectedTabIndex.value == 1 ? true : false,
                                                data: (kHomeController.selectedTabIndex.value == 2) ? (kHomeController.courseWorkList[index]) : null,
                                                subject: widget.data ?? Course(),
                                              );
                                            });
                                      },
                                    )
                                  : (kHomeController.courseLoading.value)
                                      ? const Center(child: CircularProgressIndicator())
                                      : noDataFoundWidget(message: AppTexts.noClassWork);
                            })
                        : StreamBuilder<Object>(
                            stream: kHomeController.userTodoList.stream,
                            builder: (context, snapshot) {
                              return StreamBuilder<Object>(
                                  stream: kHomeController.userTodoProgress.stream,
                                  builder: (context, snapshot) {
                                    return (kHomeController.userTodoList.isNotEmpty)
                                        ? ListView.separated(
                                            itemCount: kHomeController.userTodoList.length,
                                            shrinkWrap: true,
                                            primary: false,
                                            separatorBuilder: (context, index) {
                                              return heightBox(height: 12);
                                            },
                                            itemBuilder: (context, index) {
                                              return todoCard(
                                                // subject: Course(),
                                                data: kHomeController.userTodoList[index],
                                              );
                                            },
                                          )
                                        : (kHomeController.userTodoProgress.value)
                                            ? const Center(child: CircularProgressIndicator())
                                            : noDataFoundWidget(message: AppTexts.noTodoFound);
                                  });
                            });
              });
        });
  }

  Widget userTile(ClassUserModelData data) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // border: Border.all(color: AppColors.buttonColor, width: 3),
              ),
              child: getNetworkImage(
                url: data.profileUrl ?? "",
                borderRadius: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          widthBox(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${data.firstname ?? ""} ${data.lastname ?? ""}", style: black18bold),
                heightBox(),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              hideKeyBoard(context);
              await chatButtonClick(
                context,
                name: "${data.firstname ?? " "} ${data.lastname ?? " "}",
                id: "${(kHomeController.userData.value.userId ?? "").toString()}-${(data.userID ?? " ").toString()}",
                image: data.profileUrl ?? "",
                userIdList: [
                  (kHomeController.userData.value.userId ?? "").toString(),
                  (data.userID ?? " ").toString(),
                ],
              );
            },
            icon: const Icon(Icons.messenger_outline_outlined, color: AppColors.buttonColor),
          )
        ],
      ),
    );
  }

  Widget topSection() {
    return Row(
      children: [
        Expanded(
          child: tab(
              image: Assets.iconsShowAssignment,
              text: AppTexts.todos,
              index: 1,
              onTap: () {
                kHomeController.getClassTaskList(classID: widget.data?.id ?? "", showProgress: /*kHomeController.userTodoList.isEmpty ? true : */ false);
              }),
        ),
        widthBox(),
        Expanded(
          child: tab(
              image: Assets.iconsAssignmentAdded,
              text: AppTexts.classWork,
              index: 2,
              onTap: () {
                kHomeController.getAllAssignmentList(widget.data?.id ?? "");
              }),
        ),
        widthBox(),
        Expanded(
          child: tab(
              image: Assets.iconsOtherPeopleTodo,
              text: AppTexts.people,
              index: 3,
              showCircle: false,
              onTap: () {
                kHomeController.getUsersOfClass(widget.data?.id ?? "", () {}, showProgress: /*kHomeController.classUserList.isEmpty ? true : */ false);
                kHomeController.getOtherTaskList(classID: widget.data?.id ?? "", showProgress: /*kHomeController.otherUserTaskList.isEmpty ? true :*/ false);
              }),
        ),
      ],
    );
  }

  Widget tab({
    required String image,
    required String text,
    required int index,
    bool? showCircle,
    Function()? onTap,
  }) {
    return StreamBuilder<Object>(
        stream: kHomeController.selectedTabIndex.stream,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              kHomeController.selectedTabIndex.value = index;
              if (onTap != null) {
                onTap();
              }
            },
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (index == kHomeController.selectedTabIndex.value) ? AppColors.borderColor : AppColors.grey,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        image,
                        color: (index == kHomeController.selectedTabIndex.value) ? AppColors.borderColor : AppColors.grey,
                        scale: 3.5,
                      ),
                      heightBox(),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: grey14w500.copyWith(
                          color: (index == kHomeController.selectedTabIndex.value) ? AppColors.borderColor : AppColors.grey,
                          fontWeight: (index == kHomeController.selectedTabIndex.value) ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showCircle ?? false)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red,
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
