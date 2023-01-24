import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thia/utils/utils.dart';

class FirebaseNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static initializeService() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
      if (message.notification != null) {
        PushNotificationModel model = PushNotificationModel();
        model.title = message.notification!.title;
        model.body = message.notification!.body;
        showNotification(model);
      } else {
        PushNotificationModel model = PushNotificationModel();
        model.title = message.data["title"];
        model.body = message.data["body"];
        showNotification(model);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      ///Handle tap here event.data["id"]
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: true);
    if (!isNotEmptyString(getFcmToken())) {
      firebaseMessaging.getToken().then((String? token) {
        assert(token != null);
        showLog("FCM-TOKEN $token");
        setFcmToken(token!);
      });
    }
  }

  static showNotification(PushNotificationModel data) async {
    AndroidNotificationDetails android = const AndroidNotificationDetails('ziomls_channel_id', 'ziomls_channel_name',
        channelDescription: 'ziomls_channel_description', priority: Priority.high, importance: Importance.max, icon: '@mipmap/ic_launcher');
    DarwinNotificationDetails iOS = const DarwinNotificationDetails();
    NotificationDetails platform = NotificationDetails(android: android, iOS: iOS);
    var jsonData = jsonEncode(data);
    await flutterLocalNotificationsPlugin.show(123, data.title, data.body, platform, payload: jsonData);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // showLog('Handling a background message ${message.messageId}');
    // showSnackBar(title: "Notification", message: "Notification message");
  }
}

class NotificationResponseModel {
  NotificationResponseModel({
    this.status,
    this.success,
    this.message,
  });

  int? status;
  bool? success;
  String? message;

  NotificationResponseModel.fromJson(dynamic json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['success'] = success;
    map['message'] = message;
    return map;
  }
}

/*
@JsonSerializable(explicitToJson: true)
class NotificationResponseData {
  NotificationResponseData({
    this.id,
    this.userId,
    this.type,
    this.isRead,
    this.refId,
    this.title,
    this.description,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.isSelected,
  });

  int? id;
  int? userId;
  int? type;
  int? isRead;
  @JsonKey(name: 'ref_id')
  String? refId;
  String? title;
  String? description;
  String? image;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;

  ///For Developer Use Only
  bool? isSelected;

  factory NotificationResponseData.fromJson(Map<String, dynamic> json) => _$NotificationResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseDataToJson(this);
}
*/

class PushNotificationModel {
  PushNotificationModel({this.title, this.body, this.data});

  String? title;
  String? body;
  PushNotificationData? data;

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    data = json['data'] != null ? PushNotificationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class PushNotificationData {
  PushNotificationData({this.id, this.title, this.createdat, this.description, this.image, this.url});

  int? id;
  String? title;
  String? description;
  String? url;
  String? image;
  String? createdat;

  PushNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    image = json['image'];
    createdat = json['createdat'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['url'] = url;
    map['image'] = image;
    map['createdat'] = createdat;
    return map;
  }
}
