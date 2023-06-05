import 'package:thia/modules/home_module/model/calender_task_list_model.dart';

class ClassTodoModel {
/*
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "taskID": 32,
      "userID": 42,
      "classID": "587252296793",
      "name": "testing",
      "details": "this is for testing purpose",
      "duedate": "2023-02-22T08:00:00.000Z",
      "priority": 1,
      "private": false,
      "time": "21:00:00.000000"
    }
  ]
}
*/

  bool? success;
  String? message;
  List<TodoModel?>? data;

  ClassTodoModel({
    this.success,
    this.message,
    this.data,
  });
  ClassTodoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <TodoModel>[];
      v.forEach((v) {
        arr0.add(TodoModel.fromJson(v));
      });
      data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    return data;
  }
}
