import 'package:get/get.dart';
import 'package:thia/modules/home_module/controller/home_controller.dart';

class AppBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Get.put<MainController>(MainController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}

// MainController kMainController = Get.put(MainController());
HomeController kHomeController = Get.put(HomeController());
