import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../services/api_service_call.dart';
import '../../../utils/utils.dart';
import '../../home_module/model/class_user_model.dart';
import '../model/all_notification_model.dart';
import '../model/generate_deep_link_model.dart';
import '../model/get_all_user_model.dart';

class ChatController extends GetxController {
  Future changeGroupName(Channel channel, String name) async {
    await channel.updateName(name).whenComplete(() {
      channel.watch();
    });
  }

  Future changeGroupImage(Channel channel, String url) async {
    await channel.updateImage(url).whenComplete(() {
      channel.watch();
    });
  }

  Future leaveGroup(Channel channel, List<String> memberIds) async {
    await channel.removeMembers(memberIds);
    // channel.watch();
  }

  Rx<GetAllUserModel> getAllUserModel = GetAllUserModel().obs;
  RxList<ClassUserModelData> allUserList = <ClassUserModelData>[].obs;

  getAllUser(Map<String, dynamic> params, Function() callBack) {
    Api().call(
      params: params,
      url: ApiConfig.getAllUser,
      success: (Map<String, dynamic> response) async {
        getAllUserModel.value = GetAllUserModel.fromJson(response);
        allUserList.clear();
        getAllUserModel.value.data?.forEach((element) {
          if (element?.userID != (kHomeController.userData.value.userId ?? "")) {
            allUserList.add(element ?? ClassUserModelData());
          }
        });
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }

  Rx<GenerateDeepLinkModel> generateLinkModel = GenerateDeepLinkModel().obs;

  generateLink(Map<String, dynamic> params, Function() callBack) {
    Api().call(
      params: params,
      url: ApiConfig.generateLink,
      success: (Map<String, dynamic> response) async {
        generateLinkModel.value = GenerateDeepLinkModel.fromJson(response);
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<String> createDynamicLink({
    required String channelId,
    required String channelName,
    required String channelImage,
  }) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://thia.page.link',
      link: Uri.parse('https://thiaapp.com/invite?channel_id=$channelId&channel_name=$channelName&channel_image=$channelImage'),
      androidParameters: const AndroidParameters(packageName: 'com.app.thia', minimumVersion: 1),
      iosParameters: const IOSParameters(bundleId: 'com.app.thia', minimumVersion: '1', appStoreId: ''),
    );
    final url1 = await dynamicLinks.buildShortLink(parameters);

    print(url1.shortUrl);
    return url1.shortUrl.toString();
  }

  sendNotification(Map<String, dynamic> params, Function() callBack) {
    Api().call(
      params: params,
      url: ApiConfig.sendNotification,
      success: (Map<String, dynamic> response) async {
        callBack();
        showSnackBar(title: ApiConfig.success, message: "Invitation send successfully...");
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }

  Rx<AllNotificationModel> allNotificationModel = AllNotificationModel().obs;
  RxList<AllNotificationModelData> allNotificationList = <AllNotificationModelData>[].obs;

  getAllNotification(Map<String, dynamic> params, Function() callBack) {
    Api().call(
      params: params,
      url: ApiConfig.getAllNotification,
      success: (Map<String, dynamic> response) async {
        allNotificationModel.value = AllNotificationModel.fromJson(response);
        allNotificationList.clear();
        allNotificationModel.value.data?.forEach((element) {
          if (element?.accepted != true && element?.rejected != true) {
            allNotificationList.add(element ?? AllNotificationModelData());
          }
        });
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }

  acceptNotification(String id, Function() callBack) {
    Api().call(
      params: {},
      url: ApiConfig.acceptNotification + id,
      success: (Map<String, dynamic> response) async {
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }

  rejectNotification(String id, Function() callBack) {
    Api().call(
      params: {},
      url: ApiConfig.rejectNotification + id,
      success: (Map<String, dynamic> response) async {
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }
}
