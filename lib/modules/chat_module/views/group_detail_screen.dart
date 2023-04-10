import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/modules/chat_module/views/change_image_screen.dart';
import 'package:thia/utils/utils.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({
    Key? key,
    // required this.title,
    // required this.image,
    // required this.members,
    required this.channel,
  }) : super(key: key);

  // final String title;
  // final String image;
  // final List<Member> members;
  final Channel channel;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  List<Member> members = [];

  RxBool isLoading = false.obs;
  RxBool isMuted = false.obs;

  @override
  void initState() {
    super.initState();
    getChannelMembers();
  }

  getChannelMembers() async {
    isLoading.value = true;
    isMuted.value = widget.channel.isMuted;
    await widget.channel.queryMembers().then((value) {
      showLog("members ===> ${value.members}");
      value.members.forEach(
        (element) {
          members.add(element);
        },
      );
      setState(() {
        isLoading.value = false;
      });
    });
  }

  changeImage(String url) async {
    await widget.channel.updateImage(url).whenComplete(() {
      setState(() {
        widget.channel.watch();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // showLog("members ===> $members");
    return Scaffold(
      appBar: GetAppBar(context, widget.channel.name ?? ""),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          heightBox(height: 20),
          Center(
            child: Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(65)),
                  child: getNetworkImage(
                    url: widget.channel.image ?? "",
                    borderRadius: 65,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => ChangeImageScreen(image: widget.channel.image ?? ""))?.then((value) {
                        showLog("return image ===> $value");
                        changeImage(value.toString());
                        // imageUrl.value = value.toString();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
                      child: Icon(Icons.edit_outlined, color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          heightBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mute Group", style: black18w600),
              StreamBuilder<Object>(
                  stream: isMuted.stream,
                  builder: (context, snapshot) {
                    return Switch(
                      onChanged: (value) async {
                        if (isMuted.value) {
                          await widget.channel.unmute();
                        } else {
                          await widget.channel.mute();
                        }
                        await widget.channel.watch();
                        isMuted.toggle();
                        setState(() {});
                      },
                      value: isMuted.value,
                      activeColor: AppColors.primaryColor,
                      activeTrackColor: AppColors.primaryColor.withOpacity(0.6),
                      inactiveThumbColor: AppColors.primaryColor,
                      inactiveTrackColor: AppColors.primaryColor.withOpacity(0.6),
                    );
                  }),
            ],
          ),
          heightBox(height: 10),
          const Divider(),
          heightBox(height: 10),
          Text("Members", style: primary20w600),
          heightBox(height: 15),
          (isLoading.value)
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  separatorBuilder: (context, index) => heightBox(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return userDetailsTile(members[index]);
                  },
                )
        ],
      ),
    );
  }

  Widget userDetailsTile(Member data) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // border: Border.all(color: AppColors.buttonColor, width: 3),
              ),
              child: getNetworkImage(
                url: data.user?.image ?? "",
                borderRadius: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          widthBox(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.user?.name ?? "", style: black18bold),
                heightBox(),
              ],
            ),
          ),
          if (((kHomeController.userData.value.userId ?? 0).toString()) != data.user?.id)
            IconButton(
              onPressed: () async {
                hideKeyBoard(context);
                await chatButtonClick(
                  context,
                  // name: "${data.firstname ?? ""} ${data.lastname ?? ""}",
                  id: "${(kHomeController.userData.value.userId ?? "").toString()}-${(data.user?.id ?? "").toString()}",
                  // image: data.profileUrl ?? "",
                  userIdList: [
                    (kHomeController.userData.value.userId ?? "").toString(),
                    (data.user?.id ?? "").toString(),
                  ],
                );
              },
              icon: Icon(Icons.messenger_outline_outlined, color: AppColors.primaryColor),
            )
        ],
      ),
    );
  }
}
