import 'package:get/get.dart';
import 'package:thia/modules/home_module/controller/home_controller.dart';

import '../modules/chat_module/controller/chat_controller.dart';

class AppBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ChatController>(ChatController(), permanent: true);
  }
}

HomeController kHomeController = Get.put(HomeController());
ChatController kChatController = Get.put(ChatController());
