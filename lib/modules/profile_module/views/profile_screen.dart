import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/modules/auth/views/login_screen.dart';
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
                      border: Border.all(color: AppColors.buttonColor, width: 3),
                    ),
                    child: getNetworkImage(
                      url:
                          "https://images.unsplash.com/photo-1669993427100-221137cc7513?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDYxfHRvd0paRnNrcEdnfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=900&q=60",
                      borderRadius: 65,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                heightBox(height: 15),
                Center(child: Text(AppTexts.johnDeo, style: black22w700)),
                heightBox(),
                Center(child: Text("johndeo@gmail.com", style: grey16w500)),
              ],
            ),
          ),
          heightBox(),
          Divider(color: AppColors.black.withOpacity(0.1), thickness: 1.5),
          heightBox(),
          tile1(title: AppTexts.notification, icon: CupertinoIcons.bell),
          tile1(title: AppTexts.theme, icon: CupertinoIcons.sparkles),
          tile1(title: AppTexts.rateUs, icon: CupertinoIcons.star),
          tile1(title: AppTexts.support, icon: Icons.help_outline),
          tile1(title: AppTexts.shareApp, icon: Icons.share_outlined),
          tile1(title: AppTexts.aboutUs, icon: Icons.help_outline),
          heightBox(),
          GetButton(
            ontap: () {
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
          )
        ],
      ),
    );
  }

  Widget tile1({required title, required IconData icon}) {
    return Padding(
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
    );
  }
}
