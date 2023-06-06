import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/modules/chat_module/views/create_group_screen.dart';
import 'package:thia/utils/utils.dart';

import '../../home_module/model/class_user_model.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key, required this.channel, this.isFromInvite}) : super(key: key);
  final Channel channel;
  final bool? isFromInvite;

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final searchController = TextEditingController();
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)),
    borderRadius: BorderRadius.circular(15.0),
  );

  RxList<ClassUserModelData> selectedUserList = <ClassUserModelData>[].obs;
  RxList<ClassUserModelData> searchUserList = <ClassUserModelData>[].obs;
  List<Member> members = [];

  getChannelMembers() async {
    await widget.channel.queryMembers().then((value) {
      showLog("members ===> ${value.members}");
      value.members.forEach((element) {
        members.add(element);
      });
    });
  }

  // String? _linkMessage;
  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  //
  // final String dynamicLink = 'https://example/helloworld';
  //
  // // final String link = 'https://flutterfiretests.page.link/MEGs';
  //
  // Future<String> createDynamicLink(bool short) async {
  //   // final parameters = DynamicLinkParameters(
  //   //   uriPrefix: 'https://thia.page.link',
  //   //   link: Uri.parse('https://test/welcome?userId=1'),
  //   //   androidParameters: const AndroidParameters(packageName: "com.app.thia"),
  //   //   iosParameters: const IOSParameters(bundleId: "com.app.thia", appStoreId: '295288564239'),
  //   // );
  //   // // var dynamicUrl = await parameters.buildUrl();
  //   // final shortLink = parameters.link;
  //   // // final shortLink = await parameters.buildShortLink();
  //   // final shortUrl = shortLink.path;
  //   const baseUrl = "https://thia.page.link";
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: baseUrl,
  //     // longDynamicLink: Uri.parse(
  //     //   '$baseUrl?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
  //     // ),
  //     // link: Uri.parse(dynamicLink),
  //     link: Uri.parse("https://test/welcome?userId=1"),
  //     navigationInfoParameters: const NavigationInfoParameters(forcedRedirectEnabled: true),
  //     androidParameters: const AndroidParameters(
  //       packageName: 'com.app.thia',
  //       // minimumVersion: 0,
  //     ),
  //     iosParameters: const IOSParameters(
  //       bundleId: 'com.app.thia',
  //       // minimumVersion: '0',
  //     ),
  //   );
  //
  //   Uri url;
  //   if (short) {
  //     final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
  //     url = shortLink.shortUrl;
  //   } else {
  //     url = await dynamicLinks.buildLink(parameters);
  //   }
  //
  //   setState(() {
  //     _linkMessage = url.toString();
  //   });
  //   showLog("Url ===> $_linkMessage");
  //   return _linkMessage.toString();
  // }

  @override
  void initState() {
    super.initState();
    getChannelMembers();
    kChatController.getAllUser({}, () {
      kChatController.allUserList.forEach((element) {
        if (members.where((x) => x.user?.id == (element.userID ?? 0).toString()).isEmpty) {
          searchUserList.add(element);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(
        context,
        widget.isFromInvite == true ? AppTexts.invite : AppTexts.addMembers,
        actionWidgets: [
          InkWell(
            onTap: () {
              final params = {
                "channel_id": widget.channel.id ?? "",
                "channel_name": widget.channel.name ?? "",
                // "Id": widget.channel.id ?? "",
                // "name": widget.channel.name ?? "",
                "channel_image": widget.channel.image ?? "",
              };
              // kChatController.createDynamicLink(context: context, itemId: "123");
              kChatController.createDynamicLink1(
                channelId: widget.channel.id ?? "",
                channelName: widget.channel.name ?? "",
                channelImage: widget.channel.image ?? "",
              );
              kChatController.generateLink(params, () async {
                if (kChatController.generateLinkModel.value.data?.url?.isNotEmpty ?? false) {
                  await onShare(
                    context,
                    title: kChatController.generateLinkModel.value.data?.url ?? "",
                    subject: appName,
                  );
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(AppTexts.shareLink, style: primary16w600),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetButton(
        text: widget.isFromInvite == true ? AppTexts.invite : AppTexts.addMembers,
        ontap: () async {
          hideKeyBoard(context);
          if (widget.isFromInvite == true) {
            // await widget.channel.inviteMembers(users).then((value) {
            //   widget.channel.watch();
            //   Get.back();
            //   Get.back();
            // });
            final userMapList = selectedUserList
                .map((element) => {
                      "userID": element.userID ?? "",
                      "fcmtoken": element.fcmtoken ?? "",
                    })
                .toList();

            final params = {
              "users": userMapList,
              "channel_id": widget.channel.id ?? "",
              "channel_name": widget.channel.name ?? "",
              "channel_image": widget.channel.image ?? "",
            };
            showLog("params ===> $params");
            kChatController.sendNotification(params, () {
              Get.back();
            });
          } else {
            final users = selectedUserList.map((element) => (element.userID ?? 0).toString()).toList();
            if (selectedUserList.isNotEmpty) {
              await widget.channel.addMembers(users).then((value) {
                widget.channel.watch();
                Get.back();
                Get.back();
              });
            }
          }
        },
        margin: 15,
        borderRadius: 15,
        gradient: AppColors.purpleGradient,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          heightBox(height: 15),
          GetTextField(
            hintText: AppTexts.enterUserName,
            title: AppTexts.searchUserName,
            outlineInputBorder: border,
            textEditingController: searchController,
            preFixIcon: Icon(Icons.search, color: AppColors.grey),
            onChangedFunction: (String val) {
              onSearchTextChanged(val);
            },
          ),
          heightBox(height: 15),
          StreamBuilder<Object>(
              stream: searchUserList.stream,
              builder: (context, snapshot) {
                if (searchUserList.isEmpty) {
                  return noDataFoundWidget(message: AppTexts.noUser);
                }
                return ListView.separated(
                  itemCount: searchUserList.length,
                  shrinkWrap: true,
                  primary: false,
                  separatorBuilder: (context, index) => Divider(endIndent: 10, indent: 10, color: AppColors.black.withOpacity(0.35)),
                  itemBuilder: (context, index) {
                    return checkUserTile(data: searchUserList[index], selectedUserList: selectedUserList);
                  },
                );
              }),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchUserList.clear();
    if (text.isEmpty) {
      kChatController.allUserList.forEach((element) {
        searchUserList.add(element);
      });
      return;
    }

    kChatController.allUserList.forEach((userDetail) {
      if ((userDetail.firstname ?? "").toLowerCase().contains(text.toLowerCase()) || (userDetail.lastname ?? "").toLowerCase().contains(text.toLowerCase())) {
        searchUserList.add(userDetail);
      }
    });
  }
}
