// To parse this JSON data, do
//
//     final testModel = testModelFromJson(jsonString);

import 'dart:convert';

TestModel testModelFromJson(String str) => TestModel.fromJson(json.decode(str));

String testModelToJson(TestModel data) => json.encode(data.toJson());

class TestModel {
  bool? success;
  String? message;
  String? id;
  Recived? recived;

  TestModel({
    this.success,
    this.message,
    this.id,
    this.recived,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        success: json["success"],
        message: json["message"],
        id: json["id"],
        recived: json["recived"] == null ? null : Recived.fromJson(json["recived"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "id": id,
        "recived": recived?.toJson(),
      };
}

class Recived {
  Recived();

  factory Recived.fromJson(Map<String, dynamic> json) => Recived();

  Map<String, dynamic> toJson() => {};
}
