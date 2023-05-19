import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../utils/utils.dart';
import '../auth/views/login_screen.dart';
import '../chat_module/views/stream_chat_page.dart';
import '../home_module/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    bool isLogin = getIsLogin();
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      if (isLogin) {
        await initDynamicLinks();
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      showLog("dynamicLinkData ===> $dynamicLinkData");
      String name = "";
      String id = "";
      String image = "";
      const url = "https://thia.page.link/fMNh?channel_id=516573860629&channel_name=Pratik&channel_image=https://i.imgur.com/ReSxSJU.png&";
      int startIndex = url.indexOf("channel_id");
      int indexOfChannelName = url.indexOf("&channel_name=");
      int indexOfChannelImage = url.indexOf("&channel_image=");
      id = url.substring(startIndex + "channel_id=".length, indexOfChannelName);
      name = url.substring(indexOfChannelName + 1 + "channel_name=".length, indexOfChannelImage);
      image = url.substring(indexOfChannelImage + 1 + "channel_image=".length, url.length - 1);

      // showLog("start index ===> ${url.indexOf("channel_id")}");
      showLog("id ===> $id");
      showLog("name ===> $name");
      showLog("image ===> $image");

      await chatButtonClick(
        context,
        name: name,
        id: id,
        image: image,
        userIdList: [(kHomeController.userData.value.userId ?? "").toString()],
      );
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Get.to(() => const ChannelListPage());
      });
      // Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      showLog('onLink error');
      showLog(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // fit: StackFit.expand,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              Assets.imagesSplash,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(child: Image.asset(Assets.imagesAppLogo, scale: 4)),
        ],
      ),
    );
  }
}
