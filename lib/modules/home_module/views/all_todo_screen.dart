import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/utils/utils.dart';

import '../../../main.dart';

class AllTodoScreen extends StatefulWidget {
  const AllTodoScreen({Key? key, required this.selectedCount}) : super(key: key);
  final int selectedCount;

  @override
  State<AllTodoScreen> createState() => _AllTodoScreenState();
}

class _AllTodoScreenState extends State<AllTodoScreen> {
  RxInt selectedTab = 1.obs;

  @override
  void initState() {
    super.initState();
    selectedTab.value = widget.selectedCount;
    // if (kHomeController.userTaskTodoList.isEmpty) {
    kHomeController.getUsesTaskList(showProgress: false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    showLog(getPreference.read(PrefConstants.loginToken));
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.allTodo),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            kHomeController.getUsesTaskList(showProgress: false);
          },
          child: StreamBuilder<Object>(
              stream: kHomeController.userTaskTodoProgress.stream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    prioritySection(),
                    heightBox(height: 15),
                    (kHomeController.userTaskTodoProgress.value)
                        ? const Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : StreamBuilder<Object>(
                            stream: kHomeController.userTaskTodoList.stream,
                            builder: (context, snapshot) {
                              return StreamBuilder<Object>(
                                  stream: selectedTab.stream,
                                  builder: (context, snapshot) {
                                    return Expanded(
                                      child: (selectedTab.value == 1 && kHomeController.userTaskTodoList.where((p0) => (p0.priority == 1)).isEmpty)
                                          ? noDataFoundWidget(message: AppTexts.noTodoFound)
                                          : (selectedTab.value == 2 && kHomeController.userTaskTodoList.where((p0) => (p0.priority == 2)).isEmpty)
                                              ? noDataFoundWidget(message: AppTexts.noTodoFound)
                                              : (selectedTab.value == 3 && kHomeController.userTaskTodoList.where((p0) => (p0.priority == 3)).isEmpty)
                                                  ? noDataFoundWidget(message: AppTexts.noTodoFound)
                                                  : ListView.separated(
                                                      itemCount: selectedTab.value == 1
                                                          ? (kHomeController.userTaskTodoList.where((p0) => (p0.priority == 1)).length)
                                                          : selectedTab.value == 2
                                                              ? kHomeController.userTaskTodoList.where((p0) => (p0.priority == 2)).length
                                                              : kHomeController.userTaskTodoList.where((p0) => (p0.priority == 3)).length,
                                                      shrinkWrap: true,
                                                      primary: true,
                                                      separatorBuilder: (context, index) => heightBox(height: 12),
                                                      itemBuilder: (context, index) {
                                                        return todoCard(
                                                            data: selectedTab.value == 1
                                                                ? kHomeController.userTaskTodoList.where((p0) => (p0.priority == 1)).toList()[index]
                                                                : selectedTab.value == 2
                                                                    ? kHomeController.userTaskTodoList.where((p0) => (p0.priority == 2)).toList()[index]
                                                                    : kHomeController.userTaskTodoList.where((p0) => (p0.priority == 3)).toList()[index]);
                                                      },
                                                    ),
                                    );
                                  });
                            }),
                  ],
                );
              }),
        ),
      ),
    );
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
    return StreamBuilder<Object>(
        stream: selectedTab.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  selectedTab.value = selectedCount;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color,
                    border: selectedCount == selectedTab.value ? Border.all(color: AppColors.primaryColor, width: 2) : null,
                  ),
                  child: Text(data, style: white18w700),
                ),
              ),
              heightBox(),
              Text("$priority Priority", style: black16w500.copyWith(color: selectedCount == selectedTab.value ? AppColors.black : AppColors.grey)),
            ],
          );
        });
  }
}
