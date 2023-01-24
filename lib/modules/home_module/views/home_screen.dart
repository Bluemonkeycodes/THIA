import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/modules/profile_module/views/profile_screen.dart';

import '../../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20).copyWith(top: 40, bottom: 0),
        child: Column(
          children: [
            topSection(),
            heightBox(height: 30),
            prioritySection(),
            heightBox(),
            Expanded(child: cardSection()),
          ],
        ),
      ),
      bottomNavigationBar: commonBottomBar(),
    );
  }

  Widget cardSection() {
    return ListView.separated(
      itemCount: 10,
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 10),
      separatorBuilder: (context, index) {
        return heightBox(height: 25);
      },
      itemBuilder: (context, index) {
        return classRoomCard();
      },
    );
  }

  Widget prioritySection() {
    return Row(
      children: [
        Expanded(child: priorityTab(color: AppColors.red, count: "2", priority: AppTexts.high)),
        Expanded(child: priorityTab(color: AppColors.orange, count: "3", priority: AppTexts.mid)),
        Expanded(child: priorityTab(color: AppColors.yellow, count: "5", priority: AppTexts.low)),
      ],
    );
  }

  Widget priorityTab({
    required Color color,
    required String count,
    required String priority,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 7),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
          child: Text(count, style: white18w700),
        ),
        heightBox(),
        Text("$priority Priority", style: black16w500),
      ],
    );
  }

  Widget topSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appName, style: grey14w700),
              heightBox(),
              Text(AppTexts.johnDeo, style: black24w700),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              Get.to(() => const ProfileScreen());
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(Assets.imagesDummyProfileImage, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
