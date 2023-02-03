import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:thia/utils/utils.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
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
              showNavigationArrow: true,
              initialSelectedDate: DateTime.now(),
              headerStyle: DateRangePickerHeaderStyle(textStyle: black16w700),
            ),
          ),
          heightBox(height: 20),
          ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            primary: false,
            separatorBuilder: (context, index) {
              return heightBox(height: 12);
            },
            itemBuilder: (context, index) {
              return todoSection(showDate: false, showPriorityBar: true, subject: Course());
            },
          )
        ],
      ),
    );
  }
}
