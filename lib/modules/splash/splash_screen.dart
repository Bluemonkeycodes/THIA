import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../generated/assets.dart';
import '../../utils/utils.dart';
import '../auth/views/login_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isLogin = getIsLogin();
      if (isLogin) {
        await initDynamicLinks();
      }
      Future.delayed(const Duration(seconds: 3)).then((value) async {
        if (isLogin) {
          Get.offAll(() => const HomeScreen());
        } else {
          Get.offAll(() => const LoginScreen());
        }
      });
    });
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    // if (await dynamicLinks.onLink.isEmpty) {
    //   bool isLogin = getIsLogin();
    //   if (isLogin) {
    //     Get.offAll(() => const HomeScreen());
    //   } else {
    //     Get.offAll(() => const LoginScreen());
    //   }
    // } else {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      showLog("dynamicLinkData ===> ${dynamicLinkData.link.path}");
      var x = await dynamicLinks.getInitialLink();
      showLog("link ===> ${x?.link}");
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
      Future.delayed(const Duration(seconds: 2)).then((value) async {
        try {
          Get.to(() => const HomeScreen())?.whenComplete(() async {
            // await StreamChat.of(context).client.disconnectUser();
            // await StreamChat.of(context).client.conn();
            StreamChat.of(context).client.closeConnection();
            await chatButtonClick(
              context,
              name: name,
              id: id,
              image: image,
              userIdList: [(kHomeController.userData.value.userId ?? "").toString()],
            );
          });
          // Future.delayed(const Duration(seconds: 1)).then((value) {
          //   Get.offAll(() => const ChannelListPage());
          // });
        } catch (e) {
          showLog('error ===> $e');
        }
      });
    }).onError((error) {
      showLog('onLink error');
      showLog(error.message);
    });
    // }
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
