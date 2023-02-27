import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:thia/modules/home_module/views/add_todo_screen.dart';
import 'package:thia/utils/utils.dart';

import '../model/calender_task_list_model.dart';

class TodoDetailsScreen extends StatefulWidget {
  const TodoDetailsScreen({Key? key, required this.data}) : super(key: key);
  final TodoModel data;

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  TextStyle titleStyle = black16w600;
  TextStyle descStyle = black14w500;
  TextStyle moreStyle = black14w700;

  @override
  void initState() {
    kHomeController.callTaskDetailApi(
      widget.data.taskID.toString(),
      () {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, ((widget.data.name ?? "").capitalizeFirst) ?? ""),
      bottomNavigationBar: StreamBuilder<Object>(
          stream: kHomeController.taskDetailLoader.stream,
          builder: (context, snapshot) {
            return kHomeController.taskDetailLoader.value ? const SizedBox() : bottom(context, false);
          }),
      body: StreamBuilder<Object>(
          stream: kHomeController.taskDetailLoader.stream,
          builder: (context, snapshot) {
            return kHomeController.taskDetailLoader.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    padding: const EdgeInsets.all(15),
                    children: [
                      todoCard(data: widget.data, onTap: () {}, showSubTask: true, taskDetailModel: kHomeController.taskDetailModel.value),
                      heightBox(),
                    ],
                  );
          }),
    );
  }

  Widget bottom(BuildContext context, bool isFromDetails, {Course? subject}) {
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
              iconData: Icons.edit,
              name: AppTexts.edit,
              onTap: () {
                Get.to(() => AddTodoScreen(data: widget.data, fromBottomBar: false, isFromEdit: true));
              }),
          bottomNavigationBarItem(
            iconData: Icons.done_all,
            name: AppTexts.complete,
            onTap: () {
              kHomeController.setTaskComplete((widget.data.taskID ?? 0).toString(), () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                showSnackBar(title: ApiConfig.success, message: "To-Do successfully set as completed.");
              });
            },
          ),
          bottomNavigationBarItem(
            iconData: CupertinoIcons.delete,
            name: AppTexts.delete,
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: getDeleteDialog(ontapYes: () {
                    kHomeController.deleteTask((widget.data.taskID ?? 0).toString(), () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      showSnackBar(title: ApiConfig.success, message: "To-Do successfully deleted.");
                    });
                  }, ontapNo: () {
                    Get.back();
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
