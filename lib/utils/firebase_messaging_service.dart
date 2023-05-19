import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/modules/chat_module/views/stream_chat_page.dart';
import 'package:thia/utils/common_stream_io.dart';
import 'package:thia/utils/utils.dart';

import '../main.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class FirebaseNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  BuildContext context1;

  FirebaseNotificationService({required this.context1});

  initializeService(BuildContext context) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    getStreamContext(context);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
      // final chatClient = streamChatClient!;

      showLog("initializeService message ===> $message");
      if (message.data["sender"] == "stream.chat") {
        final chatClient = StreamChat.of(context1).client;
        showStreamNotification(message, chatClient);
      } else {
        PushNotificationModel model = PushNotificationModel();
        model.title = message.notification?.title ?? "";
        model.body = message.notification?.body ?? "";
        showNotification(model);
      }
    });
    // FirebaseMessaging.instance.getInitialMessage().then((value) {
    //   showLog("tap ===> ${value.toString()}");
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      showLog("tap ===> ${event.data.toString()}");
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

  // static showNotification(PushNotificationModel data) async {
  //   AndroidNotificationDetails android = const AndroidNotificationDetails('thia_channel_id', 'thia_channel_name', channelDescription: 'thia_channel_description', priority: Priority.high, importance: Importance.max, icon: '@mipmap/ic_launcher');
  //   DarwinNotificationDetails iOS = const DarwinNotificationDetails();
  //   NotificationDetails platform = NotificationDetails(android: android, iOS: iOS);
  //   var jsonData = jsonEncode(data);
  //   await flutterLocalNotificationsPlugin.show(123, data.title, data.body, platform, payload: jsonData);
  // }
  static showNotification(PushNotificationModel data) async {
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'new_message',
      'New message notifications channel',
      priority: Priority.max,
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
    );
    DarwinNotificationDetails iOS = const DarwinNotificationDetails();
    NotificationDetails platform = NotificationDetails(android: android, iOS: iOS);
    // final data = message.data;
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        showLog("payload ===> ${notificationResponse.payload}");
        navigateFromNotification(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    flutterLocalNotificationsPlugin.show(
      1,
      data.title ?? "",
      data.body ?? "",
      platform,
      payload: jsonEncode(data),
    );
  }
}

void notificationTapBackground(NotificationResponse notificationResponse) {
  showLog('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');

  navigateFromNotification(notificationResponse);
  if (notificationResponse.input?.isNotEmpty ?? false) {
    showLog('notification action tapped with input: ${notificationResponse.input}');
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
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings()),
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
      showLog("payload ===> ${notificationResponse.payload}");
      navigateFromNotification(notificationResponse);
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  if (data['type'] == 'message.new') {
    final messageId = data['id'];
    final response = await chatClient.getMessage(messageId).onError((error, stackTrace) {
      flutterLocalNotificationsPlugin.show(
        1,
        'New message received.',
        "Tap to view",
        platform,
        payload: jsonEncode(data),
      );
      if (error.runtimeType == StreamChatNetworkError) {}
      return Future.error(error ?? Object());
    });
    showLog("notification from ===> ${((response.channel?.memberCount ?? 0) > 2) ? response.channel?.name : response.message.user?.name}");
    flutterLocalNotificationsPlugin.show(
      1,
      'New message from ${response.message.user?.name} in ${((response.channel?.memberCount ?? 0) > 2) ? response.channel?.name : response.message.user?.name}',
      response.message.text,
      platform,
      payload: jsonEncode(data),
    );
  }
}

Future<String> getUserToken() async {
  final GetStorage getPreference1 = GetStorage();
  await pref();
  return getPreference1.read(PrefConstants.loginToken) ?? "";
}

navigateFromNotification(NotificationResponse notificationResponse) async {
  showLog("notificationResponse ===> ${notificationResponse.payload}");

  StreamChatClient chatClient = StreamChatClient(StreamConfig.apikey);
  if (notificationResponse.payload != null) {
    await chatClient.connectUser(
      User(id: jsonDecode(notificationResponse.payload!)["receiver_id"]),
      await getUserToken(),
      connectWebSocket: false,
    );
    Get.to(() => const ChannelListPage());

    /*https://chat.stream-io-api.com/channels/messaging/80-81?api_key=aw46bmah6fne&user_id=81&connection_id=63fde8b4-0a05-4328-0000-000000550d6c*/

    /*https://chat.stream-io-api.com/channels/messaging/80-81/query?api_key=aw46bmah6fne&user_id=81&connection_id=63fde8b4-0a05-4328-0000-000000550d04*/

    final response = await chatClient.getMessage(jsonDecode(notificationResponse.payload!)["channel_id"]);
    // response.message.text;
    // await StreamApi.createChannel(
    //   chatClient,
    //   type: "messaging",
    //   name: response.message.id,
    //   id: jsonDecode(notificationResponse.payload!)["channel_id"],
    //   // image: (image?.isEmpty ?? false) ? kHomeController.getGroupPlaceHolder() : image,
    //   // image: (image?.isEmpty ?? false) ? "https://www.pngkey.com/png/detail/950-9501315_katie-notopoulos-katienotopoulos-i-write-about-tech-user.png" : image,
    //   // idMembers: userIdList,
    // ).then(

    //   (channel) async {
    //     // await Future.delayed(const Duration(seconds: 1));
    //     await StreamApi.watchChannel(chatClient, type: "messaging", id: jsonDecode(notificationResponse.payload!)["channel_id"]).then((value) async {
    //       return await Future.delayed(const Duration(seconds: 1)).then((value) {
    //         // hideProgressDialog();
    //         return Get.to(() => StreamChannel(channel: channel, child: ChannelPage(channel: channel)));
    //       });
    //     });
    //     // hideProgressDialog();
    //   },
    // );
    ///
    // Channel channel = Channel(chatClient, "messaging", jsonDecode(notificationResponse.payload!)["channel_id"]);
    // await StreamApi.watchChannel(chatClient, type: "messaging", id: jsonDecode(notificationResponse.payload!)["channel_id"]).then((value) {
    //   Get.to(() => StreamChannel(channel: value, child: ChannelPage(channel: value)));
    // });
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showLog("firebaseMessagingBackgroundHandler message ===> ${message.data}");

  await Firebase.initializeApp();
  final chatClient = StreamChatClient(StreamConfig.apikey);
  await chatClient.connectUser(
    User(id: message.data["receiver_id"]),
    await getUserToken(),
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
