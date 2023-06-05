import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
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

  // createDynamicLink({required String code}) async {
  //   var parameters = DynamicLinkParameters(
  //     // This should match firebase but without the username query param
  //     uriPrefix: 'https://thia.page.link',
  //     // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
  //     link: Uri.parse('https://thia.page.link/fMNh?ref=$code'),
  //     androidParameters: const AndroidParameters(packageName: 'com.app.thia', minimumVersion: 1),
  //     iosParameters: const IOSParameters(bundleId: 'com.app.thia', minimumVersion: '1', appStoreId: ''),
  //   );
  //
  //   // print(parameters.link);
  //   // print(parameters.longDynamicLink?.path);
  //   // print(parameters.longDynamicLink?.data);
  //   // print(parameters.);
  //
  //   // return Uri();
  //   Uri url = await dynamicLinks.buildLink(parameters);
  //   // final url1 = await dynamicLinks.buildShortLink(parameters);
  //
  //   showLog("url1===> $url");
  //
  //   // print(url);
  //   // showLog("url1.shortUrl ===> ${url1.shortUrl}");
  //   // return url1;
  //   final link = parameters.link;
  //   // final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
  //   //   link,
  //   //   DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  //   // );
  //   // return shortenedLink.shortUrl;
  // }

  Future createDynamicLink({
    required BuildContext context,
    String? title,
    String? image,
    required String itemId,
  }) async {
    bool short = false;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      //add urlPrefix as per point 3.2
      uriPrefix: 'https://thia.page.link',
      //add link as per point 4.7
      link: Uri.parse('thiaapp.com/fMNh?id=$itemId'),
      // link: Uri.parse('https://thia.page.link/fMNh?id=$itemId'),
      androidParameters: const AndroidParameters(
          //android/app/build.gradle
          packageName: 'com.app.thia',
          minimumVersion: 0),
      socialMetaTagParameters: SocialMetaTagParameters(title: title, imageUrl: Uri.parse(image ?? "")),
      // dynamicLinkParametersOptions: DynamicLinkParametersOptions(
      //   shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      // ),
      iosParameters: const IOSParameters(bundleId: 'com.app.thia', minimumVersion: '0'),
    );

    Uri url;
    if (short) {
      // final ShortDynamicLink shortLink = await parameters.buildShortLink();
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      // url = await parameters.buildUrl();
      url = await dynamicLinks.buildLink(parameters);
    }
    showLog("url ---> ${url.path}");
    return url.toString();
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
