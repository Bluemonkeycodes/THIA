import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // bool isLogin = (getPreference.read(PrefConstants.isLogin) ?? false);
    var isLogin = getIsLogin();

    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (isLogin) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
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
