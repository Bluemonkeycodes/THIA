import 'package:flutter/material.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/utils/utils.dart';

class ClassDetailsScreen extends StatefulWidget {
  const ClassDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, "Math"),
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
      bottomNavigationBar: commonBottomBar(),
    );
  }

  Widget mainSection() {
    return ListView.separated(
      itemCount: 10,
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return heightBox(height: 12);
      },
      itemBuilder: (context, index) {
        return StreamBuilder<Object>(
            stream: kHomeController.selectedTabIndex.stream,
            builder: (context, snapshot) {
              return todoSection(
                  showPlusButton: kHomeController.selectedTabIndex.value != 1
                      ? true
                      : false);
            });
      },
    );
  }

  Widget topSection() {
    return Row(
      children: [
        Expanded(
            child: tab(
                image: Assets.iconsShowAssignment,
                text: AppTexts.showsAssignments,
                index: 1)),
        widthBox(),
        Expanded(
            child: tab(
                image: Assets.iconsAssignmentAdded,
                text: AppTexts.assignmentsAdded,
                index: 2)),
        widthBox(),
        Expanded(
            child: tab(
                image: Assets.iconsOtherPeopleTodo,
                text: AppTexts.people,
                index: 3,
                showCircle: true)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (index == kHomeController.selectedTabIndex.value)
                          ? AppColors.borderColor
                          : AppColors.grey,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        image,
                        color: (index == kHomeController.selectedTabIndex.value)
                            ? AppColors.borderColor
                            : AppColors.grey,
                        scale: 3.5,
                      ),
                      heightBox(),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: grey14w500.copyWith(
                          color:
                              (index == kHomeController.selectedTabIndex.value)
                                  ? AppColors.borderColor
                                  : AppColors.grey,
                          fontWeight:
                              (index == kHomeController.selectedTabIndex.value)
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showCircle ?? false)
                  Positioned(
                    top: 2,
                    right: 2,
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
