import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/modules/profile_module/views/profile_screen.dart';

import '../../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    kHomeController.getClassList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.buttonColor,
        onRefresh: () async {
          kHomeController.getClassList();
        },
        child: Padding(
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
      ),
      bottomNavigationBar: commonBottomBar(context, false),
    );
  }

  Widget cardSection() {
    return StreamBuilder<Object>(
        stream: kHomeController.courseModel.stream,
        builder: (context, snapshot) {
          return ListView.separated(
            itemCount: kHomeController.courseModel.value.courses?.length ?? 0,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 10),
            separatorBuilder: (context, index) {
              return heightBox(height: 25);
            },
            itemBuilder: (context, index) {
              return classRoomCard(context, kHomeController.courseModel.value.courses?[index]);
            },
          );
        });
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
              Text(/*googleSignIn.currentUser?.displayName ??*/ "John Deo", style: black24w700),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => const ProfileScreen());
          },
          child: getNetworkImage(
            url: /*googleSignIn.currentUser?.photoUrl ??*/
                "https://images.unsplash.com/photo-1669993427100-221137cc7513?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDYxfHRvd0paRnNrcEdnfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=900&q=60",
            height: 40,
            width: 40,
            borderRadius: 10,
          ),
        ),
      ],
    );
  }
}
