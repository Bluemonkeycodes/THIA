import 'package:flutter/material.dart';
import 'package:thia/generated/assets.dart';

import '../../../utils/social_login.dart';
import '../../../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
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
          Positioned(
            top: 350,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Image.asset(Assets.imagesAppLogo, scale: 4)),
                  heightBox(height: 15),
                  Text(
                    "Your one stop shop for discussing, managing, and tracking your assignments.",
                    style: white16w500,
                    textAlign: TextAlign.center,
                  ),
                  heightBox(height: 60),
                  GetButton(
                      ontap: () {
                        googleAuth();
                        // Get.offAll(() => const HomeScreen());
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      backGroundColor: AppColors.white,
                      child: Row(
                        children: [
                          Image.asset(Assets.iconsGoogleIcon, scale: 3.5),
                          widthBox(width: 50),
                          Text(AppTexts.loginWithGoogle, style: blue18W500),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
