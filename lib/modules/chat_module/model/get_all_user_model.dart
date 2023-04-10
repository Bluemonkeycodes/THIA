import '../../home_module/model/class_user_model.dart';

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///

class GetAllUserModel {
/*
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "userID": 80,
      "firstname": "Ravin Laheri (RL)",
      "lastname": "",
      "middlename": "",
      "email": "rlaheri1999@gmail.com",
      "phonenumber": "",
      "active": true,
      "createdate": "2023-03-27T23:13:21.330Z",
      "usertypeid": 1,
      "profileUrl": "https://lh3.googleusercontent.com/a/AEdFTp7CSblU5aDPE8o2yv-RBb4MBU5Je_yh6Os478eWfQ=s96-c",
      "googleID": "f9WpNsZVqySmQvYPAGehHJ35QOM2"
    }
  ]
}
*/

  bool? success;
  String? message;
  List<ClassUserModelData?>? data;

  GetAllUserModel({
    this.success,
    this.message,
    this.data,
  });

  GetAllUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <ClassUserModelData>[];
      v.forEach((v) {
        arr0.add(ClassUserModelData.fromJson(v));
      });
      this.data = arr0;
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