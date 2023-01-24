class BooleanResponseModel {
  BooleanResponseModel({
    this.success,
    this.show,
    this.message,
  });

  BooleanResponseModel.fromJson(dynamic json) {
    show = json['show'];
    success = json['success'];
    message = json['message'];
  }
  bool? success;
  String? message;
  bool? show;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['show'] = show;
    map['success'] = success;
    map['message'] = message;
    return map;
  }
}
