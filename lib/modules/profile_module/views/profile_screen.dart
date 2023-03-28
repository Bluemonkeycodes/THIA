import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;
import 'package:thia/generated/assets.dart';
import 'package:thia/modules/auth/views/login_screen.dart';
import 'package:thia/utils/social_login.dart';
import 'package:thia/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.profile),
      bottomNavigationBar: GetButton(
        ontap: () async {
          try {
            await googleSignIn.signOut();
            await auth.signOut();
            await stream.StreamChat.of(context).client.disconnectUser();
          } catch (e) {
            showLog(e);
          }
          setIsLogin(isLogin: false);
          Get.offAll(() => const LoginScreen());
        },
        margin: 15,
        borderRadius: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.iconsLogout,
              scale: 3.5,
            ),
            widthBox(),
            Text(
              AppTexts.logout,
              style: white18w600,
            )
          ],
        ),
        gradient: AppColors.purpleGradient,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                heightBox(height: 20),
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65),
                      // border: Border.all(color: AppColors.buttonColor, width: 3),
                    ),
                    child: getNetworkImage(
                      url: kHomeController.userData.value.profileUrl ?? "",
                      borderRadius: 65,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                heightBox(height: 15),
                Center(child: Text("${kHomeController.userData.value.firstname ?? ""} ${kHomeController.userData.value.lastname ?? ""}", style: black22w700)),
                heightBox(),
                Center(child: Text(kHomeController.userData.value.email ?? "", style: grey16w500)),
              ],
            ),
          ),
          heightBox(),
          Divider(color: AppColors.black.withOpacity(0.1), thickness: 1.5),
          heightBox(),
          // tile1(title: AppTexts.notification, icon: CupertinoIcons.bell),
          // tile1(title: AppTexts.theme, icon: CupertinoIcons.sparkles),
          tile1(
              title: AppTexts.rateUs,
              icon: CupertinoIcons.star,
              onTap: () {
                if (Platform.isAndroid) {
                  launchURL("https://play.google.com/store/apps/details?id=com.app.thia");
                } else {
                  //TODO: launch ios url
                  launchURL("https://thiaapp.com/");
                }
              }),
          tile1(
              title: AppTexts.support,
              icon: Icons.help_outline,
              onTap: () {
                launchURL("https://thiaapp.com/");
              }),
          tile1(
              title: AppTexts.shareApp,
              icon: Icons.share_outlined,
              onTap: () {
                if (Platform.isAndroid) {
                  onShare(context, title: "https://play.google.com/store/apps/details?id=com.app.thia", subject: appName);
                  // launchURL("https://play.google.com/store/apps/details?id=com.app.thia");
                } else {
                  //TODO: launch ios url
                  launchURL("https://thiaapp.com/");
                }
              }),
          tile1(
              title: AppTexts.aboutUs,
              icon: Icons.help_outline,
              onTap: () {
                launchURL("https://thiaapp.com/");
              }),
        ],
      ),
    );
  }

  Widget tile1({required title, required IconData icon, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Icon(icon),
            widthBox(width: 15),
            Text(
              title,
              style: black16w500,
            )
          ],
        ),
      ),
    );
  }
}
