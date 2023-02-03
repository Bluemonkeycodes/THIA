import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart' hide Form;
import 'package:intl/intl.dart';
import 'package:thia/utils/utils.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key, this.data, required this.fromBottomBar, this.subject}) : super(key: key);
  final CourseWork? data;
  final bool fromBottomBar;
  final Course? subject;

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)), borderRadius: BorderRadius.circular(15.0));

  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final subjectController = TextEditingController();
  RxString selectedDate = "".obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subjectController.text = widget.subject?.name ?? "";
      nameController.text = widget.data?.title ?? "";
      detailsController.text = widget.data?.description ?? "";
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
            widget.fromBottomBar == true
                ? StreamBuilder<Object>(
                    stream: kHomeController.selectedCourse.stream,
                    builder: (context, snapshot) {
                      return GetDropDown(
                        menuHeight: 400.0,
                        selectionData: kHomeController.courseModel.value.courses?.map((e) => (e.name ?? "")).toList() ?? [],
                        hint: "Select class",
                        selectedValue: kHomeController.selectedCourse.value,
                        callback: (val) {
                          kHomeController.selectedCourse.value = val;
                        },
                        // filledColor: AppColors.white,
                        textStyle: black18W500,
                        iconColor: AppColors.black,
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      );
                    })
                : GetTextField(
                    hintText: AppTexts.enterName,
                    title: AppTexts.course,
                    outlineInputBorder: border,
                    isReadOnly: true,
                    textEditingController: subjectController,
                  ),
            heightBox(height: 25),
            GetTextField(
                hintText: AppTexts.enterName,
                title: AppTexts.name,
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
                        initialDate: DateTime.parse(selectedDate.value),
                        firstDate: DateTime.now(), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        showLog(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                        String formattedDate =
                            DateFormat('dd MMM yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                        showLog(formattedDate); //formatted date output using intl package =>  2022-07-04
                        //You can format date as per your need

                        selectedDate.value = formattedDate; //set foratted date to TextField value.
                      } else {
                        showLog("Date is not selected");
                      }
                    },
                    text: selectedDate.value.isNotEmpty ? selectedDate.value : AppTexts.selectDue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(selectedDate.value.isNotEmpty ? selectedDate.value : AppTexts.selectDue, style: selectedDate.value.isNotEmpty ? black14w500 : grey14w500),
                          Icon(CupertinoIcons.calendar, color: AppColors.grey),
                        ],
                      ),
                    ),
                    textStyle: selectedDate.value.isNotEmpty ? black14w500 : grey14w500,
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
                validationFunction: (val) {
                  return emptyFieldValidation(val);
                }),
            heightBox(height: 15),
            Text(AppTexts.priority, style: black16w500),
            heightBox(),
            GetDropDown(
              selectionData: ["High", "Mid", "Low"],
              hint: AppTexts.selectPriority,
              filledColor: Colors.transparent,
              textStyle: black18W500,
              border: Border.all(color: AppColors.black.withOpacity(0.1)),
            ),
            heightBox(height: 15),
            Text(AppTexts.estimatedTime, style: black16w500),
            heightBox(),
            GetButton(
              ontap: () async {
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20).copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero),
                                gradient: AppColors.lightPurpleGradient),
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
                                  onTimerDurationChanged: (value) {
                                    setState(() {
                                      // this.value = value.toString();
                                    });
                                  },
                                ),
                                heightBox(),
                                GetButton(
                                  height: 50,
                                  ontap: () {
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
                    Text(AppTexts.selectEstimatedTime, style: grey14w500),
                    Icon(Icons.watch_later_outlined, color: AppColors.grey),
                  ],
                ),
              ),
              textStyle: grey14w500,
              backGroundColor: Colors.transparent,
              border: Border.all(color: AppColors.black.withOpacity(0.1)),
              isBorder: true,
              borderRadius: 15,
            ),
            // GetTextField(hintText: AppTexts.selectEstimatedTime, title: AppTexts.estimatedTime, outlineInputBorder: border),
            heightBox(height: 45),
            GetButton(
              ontap: () {
                if (formKey.currentState?.validate() == true) {
                  hideKeyBoard(context);
                  Get.back();
                }
              },
              text: AppTexts.save,
              gradient: AppColors.purpleGradient,
            )
          ],
        ),
      ),
    );
  }
}
