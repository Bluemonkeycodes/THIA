import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/modules/auth/model/login_model.dart';
import 'package:thia/modules/chat_module/views/stream_chat_page.dart';
import 'package:thia/modules/home_module/views/add_todo_screen.dart';
import 'package:thia/modules/home_module/views/calender_screen.dart';
import 'package:thia/utils/common_stream_io.dart';
import 'package:thia/utils/utils.dart';

import '../main.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class FirebaseNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  BuildContext context1;

  FirebaseNotificationService({required this.context1});

  initializeService(BuildContext context) {
    getStreamContext(context);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
      // final chatClient = streamChatClient!;

      final chatClient = StreamChat.of(context1).client;
      showLog("initializeService message ===> ${message.data}");
      if (message.data["sender"] == "stream.chat") {
        showStreamNotification(message, chatClient);
      } else if (message.notification != null) {
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
      showLog("tap ===> ${event.data.toString()}");
      Get.to(() => const CalenderScreen());
      // Get.to(() => const ChannelListPage());

      ///Handle tap here event.data["id"]
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
    AndroidNotificationDetails android = const AndroidNotificationDetails('thia_channel_id', 'thia_channel_name', channelDescription: 'thia_channel_description', priority: Priority.high, importance: Importance.max, icon: '@mipmap/ic_launcher');
    DarwinNotificationDetails iOS = const DarwinNotificationDetails();
    NotificationDetails platform = NotificationDetails(android: android, iOS: iOS);
    var jsonData = jsonEncode(data);
    await flutterLocalNotificationsPlugin.show(123, data.title, data.body, platform, payload: jsonData);
  }
}

showStreamNotification(RemoteMessage message, StreamChatClient chatClient) async {
  AndroidNotificationDetails android = const AndroidNotificationDetails(
    'new_message',
    'New message notifications channel',
    priority: Priority.max,
    importance: Importance.max,
    icon: '@mipmap/ic_launcher',
  );
  DarwinNotificationDetails iOS = const DarwinNotificationDetails();
  NotificationDetails platform = NotificationDetails(android: android, iOS: iOS);
  final data = message.data;

  if (data['type'] == 'message.new') {
    final messageId = data['id'];
    final response = await chatClient.getMessage(messageId).onError((error, stackTrace) {
      flutterLocalNotificationsPlugin.show(
        1,
        'New message received.',
        "Tap to view",
        platform,
      );
      if (error.runtimeType == StreamChatNetworkError) {}
      return Future.error(error ?? Object());
    });
    showLog("notification from ===> ${((response.channel?.memberCount ?? 0) > 2) ? response.channel?.name : response.message.user?.name}");
    // showLog("notification from ===> ${((response.channel?.memberCount ?? 0) > 2) ? response.channel?.name : response.channel?.createdBy?.extraData["name"]}");
    flutterLocalNotificationsPlugin.show(
      1,
      'New message from ${response.message.user?.name} in ${((response.channel?.memberCount ?? 0) > 2) ? response.channel?.name : response.message.user?.name}',
      response.message.text,
      platform,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showLog("firebaseMessagingBackgroundHandler message ===> ${message.data}");

  await Firebase.initializeApp();
  // await initializeService(context1);
  // String userToken = await FirebaseMessaging.instance.getToken() ?? "";
  await pref();
  final GetStorage getPreference1 = GetStorage();

  String userToken = getPreference1.read(PrefConstants.loginToken) ?? "";
  //TODO: somehow get context below and use that
  // final chatClient = StreamChat.of(NavigationService.buildContext!).client;
  // final chatClient = streamChatClient!;
  // final chatClient = getClient();
  final chatClient = StreamChatClient(StreamConfig.apikey);
  chatClient.connectUser(
    User(id: message.data["receiver_id"]),
    userToken,
    connectWebSocket: false,
  );
  try {
    showLog("in background message received");

    showStreamNotification(message, chatClient);
  } catch (e) {
    showLog(e.toString());
  }
  // showLog('Handling a background message ${message.messageId}');
  // showSnackBar(title: "Notification", message: "Notification message");
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
