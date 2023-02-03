import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/utils/utils.dart';

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
    _tabController = TabController(length: 2, vsync: this);

    kHomeController.getAllAssignmentList(widget.data?.id ?? "");
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _tabController?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: commonBottomBar(context, true),
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
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.borderColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                25.0,
                              ),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              onTap: (index) {
                                kHomeController.selectedPeopleTabIndex.value = index;
                              },
                              // give the indicator a decoration (color and border radius)
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  25.0,
                                ),
                                color: AppColors.borderColor,
                              ),
                              labelColor: Colors.white,
                              labelStyle: white18w500,
                              unselectedLabelColor: Colors.black,
                              tabs: const [Tab(text: 'Peoples'), Tab(text: 'Assignments')],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          StreamBuilder<Object>(
                              stream: kHomeController.selectedPeopleTabIndex.stream,
                              builder: (context, snapshot) {
                                return kHomeController.selectedPeopleTabIndex.value == 0
                                    ? Expanded(
                                        child: ListView.separated(
                                        itemCount: 10,
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            endIndent: 10,
                                            indent: 10,
                                            color: AppColors.black.withOpacity(0.35),
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              hideKeyBoard(context);
                                              // Get.to(() => const MessagesScreen());
                                            },
                                            child: Padding(
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
                                                        border: Border.all(color: AppColors.buttonColor, width: 3),
                                                      ),
                                                      child: getNetworkImage(
                                                        url:
                                                            "https://images.unsplash.com/photo-1669993427100-221137cc7513?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDYxfHRvd0paRnNrcEdnfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=900&q=60",
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
                                                        Text("Math - John Sir", style: black18bold),
                                                        heightBox(),
                                                        Text("Hello...", style: black12w500),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.messenger_outline_outlined,
                                                    color: AppColors.buttonColor,
                                                  )
                                                  // Column(
                                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                                  //   children: [
                                                  //     Text("Just Now", style: grey12w500),
                                                  //     heightBox(),
                                                  //     Container(
                                                  //         height: 23,
                                                  //         width: 23,
                                                  //         padding: const EdgeInsets.all(3),
                                                  //         decoration: BoxDecoration(
                                                  //           gradient: AppColors.purpleGradient,
                                                  //           borderRadius: BorderRadius.circular(20),
                                                  //         ),
                                                  //         child: Center(
                                                  //           child: Text("2", style: white12w500),
                                                  //         ))
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ))
                                    : Expanded(
                                        child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          return todoSection(showPlusButton: true, showPriorityBar: false, subject: widget.data ?? Course());
                                        },
                                        separatorBuilder: (context, index) {
                                          return heightBox(height: 12);
                                        },
                                        itemCount: 10,
                                      ));
                              })
                        ],
                      )
                    : (kHomeController.selectedTabIndex.value == 2 && kHomeController.courseWorkList.isEmpty)
                        ? noDataFoundWidget()
                        : ListView.separated(
                            itemCount: kHomeController.selectedTabIndex.value == 2 ? (kHomeController.courseWorkList.length) : 10,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return heightBox(height: 12);
                            },
                            itemBuilder: (context, index) {
                              return StreamBuilder<Object>(
                                  stream: kHomeController.selectedTabIndex.stream,
                                  builder: (context, snapshot) {
                                    return todoSection(
                                      showPlusButton: kHomeController.selectedTabIndex.value != 1 ? true : false,
                                      showPriorityBar: kHomeController.selectedTabIndex.value == 1 ? true : false,
                                      data: (kHomeController.selectedTabIndex.value == 2) ? (kHomeController.courseWorkList[index]) : null,
                                      subject: widget.data ?? Course(),
                                    );
                                  });
                            },
                          );
              });
        });
  }

  Widget topSection() {
    return Row(
      children: [
        Expanded(child: tab(image: Assets.iconsShowAssignment, text: AppTexts.todos, index: 1)),
        widthBox(),
        Expanded(child: tab(image: Assets.iconsAssignmentAdded, text: AppTexts.assignments, index: 2)),
        widthBox(),
        Expanded(child: tab(image: Assets.iconsOtherPeopleTodo, text: AppTexts.people, index: 3, showCircle: true)),
      ],
    );
  }

  Widget tab({
    required String image,
    required String text,
    required int index,
    bool? showCircle,
  }) {
    return StreamBuilder<Object>(
        stream: kHomeController.selectedTabIndex.stream,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              kHomeController.selectedTabIndex.value = index;
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
