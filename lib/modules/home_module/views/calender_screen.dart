import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:thia/utils/utils.dart';

import '../model/calender_task_list_model.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void initState() {
    super.initState();
    kHomeController.getCalenderTaskList(date: selectedDate.value.toIso8601String(), showLoader: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.calendar),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: AppColors.lightPurpleGradient,
            ),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionColor: AppColors.buttonColor,
              todayHighlightColor: AppColors.buttonColor,
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 365)),
              showNavigationArrow: true,
              onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                selectedDate.value = DateTime.parse(dateRangePickerSelectionChangedArgs.value.toString());
                kHomeController.getCalenderTaskList(date: selectedDate.value.toIso8601String(), showLoader: false);
                showLog("dateRangePickerSelectionChangedArgs ===> ${DateTime.parse(dateRangePickerSelectionChangedArgs.value.toString()).toIso8601String()}");
              },
              initialSelectedDate: DateTime.now(),
              headerStyle: DateRangePickerHeaderStyle(textStyle: black16w700),
            ),
          ),
          heightBox(height: 20),
          StreamBuilder<Object>(
              stream: kHomeController.getCalenderTaskListModel.stream,
              builder: (context, snapshot) {
                return StreamBuilder<Object>(
                    stream: kHomeController.calenderTodoProgress.stream,
                    builder: (context, snapshot) {
                      return (kHomeController.calenderTodoProgress.value)
                          ? const Padding(
                              padding: EdgeInsets.only(top: 100.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : (kHomeController.getCalenderTaskListModel.value.data?.isEmpty ?? true)
                              ? noDataFoundWidget(message: AppTexts.noTodoFound)
                              : ListView.separated(
                                  itemCount: kHomeController.getCalenderTaskListModel.value.data?.length ?? 0,
                                  shrinkWrap: true,
                                  primary: false,
                                  separatorBuilder: (context, index) {
                                    return heightBox(height: 12);
                                  },
                                  itemBuilder: (context, index) {
                                    return todoCard(
                                      showDate: false,
                                      // subject: Course(),
                                      data: kHomeController.getCalenderTaskListModel.value.data?[index] ?? TodoModel(),
                                    );
                                  },
                                );
                    });
              })
        ],
      ),
    );
  }
}
