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
  OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)), borderRadius: BorderRadius.circular(15.0));

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
      appBar: GetAppBar(context, widget.isFromInvite == true ? AppTexts.invite : AppTexts.addMembers),
      bottomNavigationBar: GetButton(
        text: widget.isFromInvite == true ? AppTexts.invite : AppTexts.addMembers,
        ontap: () async {
          hideKeyBoard(context);
          List<String> users = selectedUserList.map((element) => (element.userID ?? 0).toString()).toList();
          if (widget.isFromInvite == true) {
            await widget.channel.inviteMembers(users).then((value) {
              widget.channel.watch();
              Get.back();
              Get.back();
            });

            // final client = StreamChat.of(context).client;
            // final invite = client.channel("messaging", id: widget.channel.id ?? "", extraData: {
            //   "name": widget.channel.name ?? "",
            //   "members": members,
            //   "invites": users,
            // });
            // await invite.create().then((value) {
            //   showLog("value ===> ${value.members}");
            // });
          } else {
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
