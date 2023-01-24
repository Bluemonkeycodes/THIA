import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/utils/utils.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)), borderRadius: BorderRadius.circular(15.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.addTodo),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          GetDropDown(
            selectionData: ["Math", "Science", "History"],
            hint: "Select class",
            filledColor: AppColors.black.withOpacity(0.05),
            textStyle: black18W500,
            iconColor: AppColors.black,
            border: Border.all(color: Colors.transparent),
          ),
          heightBox(height: 25),
          GetTextField(hintText: AppTexts.enterName, title: AppTexts.name, outlineInputBorder: border),
          heightBox(height: 15),
          GetTextField(hintText: AppTexts.enterDue, title: AppTexts.due, outlineInputBorder: border),
          heightBox(height: 15),
          GetTextField(hintText: AppTexts.enterDetails, title: AppTexts.details, outlineInputBorder: border),
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
              hideKeyBoard(context);
              Get.back();
            },
            text: AppTexts.save,
            gradient: AppColors.purpleGradient,
          )
        ],
      ),
    );
  }
}
