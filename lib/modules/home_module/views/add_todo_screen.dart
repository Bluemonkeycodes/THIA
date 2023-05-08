import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart' hide Form;
import 'package:thia/modules/home_module/model/calender_task_list_model.dart';
import 'package:thia/utils/utils.dart';

import '../model/task_detail_model.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key, this.data, required this.fromBottomBar, this.subject, this.isFromEdit}) : super(key: key);

  // final CourseWork? data;
  final TodoModel? data;
  final bool fromBottomBar;
  final bool? isFromEdit;
  final Course? subject;

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)), borderRadius: BorderRadius.circular(15.0));

  final nameController = TextEditingController();
  final detailsController = TextEditingController();

  // RxString selectedDate = DateFormat('dd MMM yyyy').format(DateTime.now()).obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  Rx<Duration> selectedTime = Duration.zero.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString radioValue = 'Private'.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      kHomeController.subTodoTaskList.clear();
      nameController.text = widget.data?.name ?? "";
      detailsController.text = widget.data?.details ?? "";

      try {
        selectedDate.value = DateTime.parse(widget.data?.duedate ?? "");
        selectedTime.value = parseDuration(widget.data?.time ?? "");
      } catch (e) {
        showLog("e ===> ${widget.data?.duedate}");
      }

      if (widget.data?.priority == 1) {
        kHomeController.selectedPriority.value = "High";
      } else if (widget.data?.priority == 2) {
        kHomeController.selectedPriority.value = "Mid";
      } else {
        kHomeController.selectedPriority.value = "Low";
      }

      if ((kHomeController.courseModel.value.courses ?? []).where((element) => (element) == widget.subject).isNotEmpty) {
        kHomeController.selectedCourse.value = ((kHomeController.courseModel.value.courses ?? []).where((element) => (element) == widget.subject).first);
      }

      if (widget.isFromEdit == true) {
        kHomeController.taskDetailModel.value.data?.subTask?.forEach((element) {
          if (element != null) {
            kHomeController.subTodoTaskList.add(element);
          }
        });

        kHomeController.courseModel.value.courses?.forEach((element) {
          if (element.id == widget.data?.classID) {
            kHomeController.selectedCourse.value = element;
          }
        });
      }
      // selectedDate.value = (dateFormatter("${widget.data?.dueDate?.year}-${widget.data?.dueDate?.month}-${widget.data?.dueDate?.day}") ?? DateTime.now()).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.addTodo),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Text(AppTexts.course, style: black16w500),
            heightBox(),
            /*  widget.fromBottomBar == true
                ? */

            // StreamBuilder<Object>(
            //     stream: kHomeController.selectedCourse.stream,
            //     builder: (context, snapshot) {
            //       return GetDropDown(
            //         menuHeight: 400.0,
            //         selectionData: kHomeController.courseModel.value.courses?.map((e) => (e.name ?? "")).toList() ?? [],
            //         hint: "Select class",
            //         selectedValue: kHomeController.selectedCourse.value,
            //         callback: (val) {
            //           kHomeController.selectedCourse.value = val;
            //         },
            //         // filledColor: AppColors.white,
            //         textStyle: black18W500,
            //         iconColor: AppColors.black,
            //         border: Border.all(color: Colors.grey.withOpacity(0.3)),
            //       );
            //     })
            Container(
              decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.grey.withOpacity(0.1))),
              child: Row(
                children: [
                  StreamBuilder<Object>(
                      stream: kHomeController.selectedCourse.stream,
                      builder: (context, snapshot) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: StreamBuilder<Object>(
                                stream: kHomeController.selectedCourse.stream,
                                builder: (context, snapshot) {
                                  return DropdownButton<Course>(
                                    borderRadius: BorderRadius.circular(10),
                                    isExpanded: true,
                                    value: kHomeController.selectedCourse.value,
                                    iconSize: 22,
                                    elevation: 16,
                                    icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.grey),
                                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: AppColors.black),
                                    underline: Container(color: Colors.transparent),
                                    onChanged: (Course? newValue) {
                                      kHomeController.selectedCourse.value = newValue ?? Course();
                                    },
                                    hint: Text("Select ${AppTexts.course}", style: grey14w500.copyWith(fontWeight: FontWeight.w400)),
                                    dropdownColor: AppColors.white,
                                    // items: kHomeController.courseModel.value.courses?.where((element) => element.courseState == "ACTIVE").toList().map<DropdownMenuItem<Course>>((value) {
                                    items: kHomeController.courseModel.value.courses?.map<DropdownMenuItem<Course>>((value) {
                                      return DropdownMenuItem<Course>(
                                        value: value,
                                        child: Text(value.name ?? "", style: black14w500),
                                      );
                                    }).toList(),
                                  );
                                }),
                          ),
                        );
                      }),
                ],
              ),
            ),
            /*: GetTextField(
                    hintText: AppTexts.enterName,
                    title: AppTexts.course,
                    outlineInputBorder: border,
                    isReadOnly: true,
                    textEditingController: subjectController,
                  )*/

            heightBox(height: 15),
            GetTextField(
                hintText: AppTexts.enterTitle,
                title: AppTexts.title,
                outlineInputBorder: border,
                textEditingController: nameController,
                validationFunction: (val) {
                  return emptyFieldValidation(val);
                }),
            heightBox(height: 15),
            Text(AppTexts.due, style: black16w500),
            heightBox(),
            StreamBuilder<Object>(
                stream: selectedDate.stream,
                builder: (context, snapshot) {
                  return GetButton(
                    ontap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        selectedDate.value = pickedDate;
                      } else {
                        showLog("Date is not selected");
                      }
                    },
                    text: dateFormatter(selectedDate.value.toString()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(dateFormatter(selectedDate.value.toString()), style: black14w500),
                          Icon(CupertinoIcons.calendar, color: AppColors.grey),
                        ],
                      ),
                    ),
                    textStyle: black14w500,
                    backGroundColor: Colors.transparent,
                    border: Border.all(color: AppColors.black.withOpacity(0.1)),
                    isBorder: true,
                    borderRadius: 15,
                  );
                }),
            heightBox(height: 15),
            GetTextField(
              hintText: AppTexts.enterDetails,
              title: AppTexts.details,
              outlineInputBorder: border,
              textEditingController: detailsController,
              // validationFunction: (val) {
              //   return emptyFieldValidation(val);
              // },
            ),
            heightBox(height: 15),
            Text(AppTexts.priority, style: black16w500),
            heightBox(),
            StreamBuilder<Object>(
                stream: kHomeController.selectedPriority.stream,
                builder: (context, snapshot) {
                  return GetDropDown(
                    selectionData: kHomeController.priorityList,
                    hint: AppTexts.selectPriority,
                    filledColor: Colors.transparent,
                    textStyle: black14w500,
                    selectedValue: kHomeController.selectedPriority.value,
                    callback: (val) {
                      kHomeController.selectedPriority.value = val;
                    },
                    border: Border.all(color: AppColors.black.withOpacity(0.1)),
                  );
                }),
            heightBox(height: 15),
            Text(AppTexts.visibility, style: black16w500),
            heightBox(),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<Object>(
                      stream: radioValue.stream,
                      builder: (context, snapshot) {
                        return RadioListTile(
                          visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                          title: Text('Private', style: black14w500),
                          value: 'Private',
                          groupValue: radioValue.value,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          activeColor: AppColors.primaryColor,
                          selectedTileColor: AppColors.primaryColor,
                          onChanged: (value) {
                            radioValue.value = value.toString();
                          },
                        );
                      }),
                ),
                widthBox(),
                Expanded(
                  child: StreamBuilder<Object>(
                      stream: radioValue.stream,
                      builder: (context, snapshot) {
                        return RadioListTile(
                          visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                          title: Text('Public', style: black14w500),
                          value: 'Public',
                          groupValue: radioValue.value,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          activeColor: AppColors.primaryColor,
                          selectedTileColor: AppColors.primaryColor,
                          onChanged: (value) {
                            radioValue.value = value.toString();
                          },
                        );
                      }),
                ),
              ],
            ),
            heightBox(height: 15),
            Text(AppTexts.estimatedTime, style: black16w500),
            heightBox(),
            StreamBuilder<Object>(
                stream: selectedTime.stream,
                builder: (context, snapshot) {
                  return GetButton(
                    ontap: () async {
                      Rx<Duration>? d = Duration.zero.obs;
                      Get.dialog(
                        Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            backgroundColor: AppColors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20).copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero), gradient: AppColors.lightPurpleGradient),
                                  child: Center(child: Text(AppTexts.selectEstimatedTime, style: black16w600)),
                                ),
                                heightBox(),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      CupertinoTimerPicker(
                                        backgroundColor: AppColors.white,
                                        mode: CupertinoTimerPickerMode.hm,
                                        initialTimerDuration: selectedTime.value,
                                        onTimerDurationChanged: (value) {
                                          showLog("time ===> $value");
                                          d.value = value;
                                        },
                                      ),
                                      heightBox(),
                                      GetButton(
                                        height: 50,
                                        ontap: () {
                                          selectedTime.value = d.value;
                                          Get.back();
                                        },
                                        text: "Set",
                                        gradient: AppColors.purpleGradient,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        barrierDismissible: false,
                      );
                    },
                    text: AppTexts.selectEstimatedTime,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            printDuration(selectedTime.value),
                            style: black14w500,
                          ),
                          Icon(Icons.watch_later_outlined, color: AppColors.grey),
                        ],
                      ),
                    ),
                    textStyle: grey14w500,
                    backGroundColor: Colors.transparent,
                    border: Border.all(color: AppColors.black.withOpacity(0.1)),
                    isBorder: true,
                    borderRadius: 15,
                  );
                }),
            heightBox(),
            Row(
              children: [
                Expanded(child: Text(AppTexts.subTodo, style: black16w500)),
                IconButton(
                    onPressed: () {
                      kHomeController.subTodoTaskList.add(TaskDetailModelDataSubTask());
                    },
                    icon: Icon(
                      Icons.add_circle_outline_sharp,
                      color: AppColors.primaryColor,
                    ))
              ],
            ),
            heightBox(),
            StreamBuilder<Object>(
                stream: kHomeController.subTodoTaskList.stream,
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: kHomeController.subTodoTaskList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GetTextField(
                                  hintText: "Enter sub todo detail",
                                  isReadOnly: kHomeController.subTodoTaskList[index].iscomplete == true ? true : false,
                                  textEditingController: TextEditingController(text: kHomeController.subTodoTaskList[index].name),
                                  validationFunction: (val) {
                                    return emptyFieldValidation(val);
                                  },
                                  onChangedFunction: (val) {
                                    kHomeController.subTodoTaskList[index].setName(val);
                                  },
                                  outlineInputBorder: border,
                                ),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (kHomeController.subTodoTaskList[index].iscomplete != true) {
                                      if (kHomeController.subTodoTaskList[index].subtaskid != null) {
                                        kHomeController.callDeleteSubTodoApi(kHomeController.subTodoTaskList[index].subtaskid.toString(), () {
                                          kHomeController.subTodoTaskList.remove(kHomeController.subTodoTaskList[index]);
                                        });
                                      } else {
                                        kHomeController.subTodoTaskList.remove(kHomeController.subTodoTaskList[index]);
                                      }
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  iconSize: 28.0,
                                  constraints: const BoxConstraints(
                                    maxHeight: 28.0,
                                    maxWidth: 28.0,
                                  ),
                                  icon: Icon(
                                    kHomeController.subTodoTaskList[index].iscomplete == true ? Icons.check_circle : Icons.delete_outline_outlined,
                                    color: kHomeController.subTodoTaskList[index].iscomplete == true ? Colors.green : AppColors.red,
                                  )),
                            ],
                          ),
                        );
                      });
                }),
            // GetTextField(hintText: AppTexts.selectEstimatedTime, title: AppTexts.estimatedTime, outlineInputBorder: border),
            heightBox(height: 45),
            GetButton(
              ontap: () {
                hideKeyBoard(context);

                if (formKey.currentState?.validate() == true) {
                  if (selectedTime.value == Duration.zero) {
                    showSnackBar(title: ApiConfig.error, message: "Select Estimated Time ");
                  } else {
                    final params = {
                      "name": nameController.text.trim(),
                      "details": detailsController.text.trim(),
                      "private": radioValue.value == "Private" ? true : false,
                      "classID": kHomeController.selectedCourse.value.id ?? "",
                      "priority": kHomeController.selectedPriority.value == "High"
                          ? 1
                          : kHomeController.selectedPriority.value == "Mid"
                              ? 2
                              : 3,
                      "duedate": selectedDate.value.toLocal().toIso8601String(),
                      "time": selectedTime.value.toString(),
                      "subTasks": kHomeController.subTodoTaskList.map((element) => element.toJson()).toList(),
                      "isSubtask": kHomeController.subTodoTaskList.isNotEmpty ? true : false,
                    };

                    if (widget.isFromEdit == true) {
                      params["taskID"] = (widget.data?.taskID ?? 0).toString();
                    }
                    print(params);
                    kHomeController.createTodo(params, () {
                      kHomeController.getPriorityCount(showLoader: false);
                      // Get.back();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      showSnackBar(title: ApiConfig.success, message: "To-Do created successfully.");
                    });
                  }
                }
              },
              text: AppTexts.save,
              gradient: AppColors.purpleGradient,
            ),
          ],
        ),
      ),
    );
  }
}
