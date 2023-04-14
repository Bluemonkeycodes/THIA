import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../services/api_service_call.dart';
import '../../../utils/utils.dart';
import '../../home_module/model/class_user_model.dart';
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
      methodType: MethodType.get,
    );
  }
}
