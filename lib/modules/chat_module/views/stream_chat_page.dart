import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../utils/utils.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser?.id ?? ""],
    ),
    channelStateSort: const [SortOption('last_message_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // showLog("current user ===> ${context1.currentUser}");
    showLog("current user ===> ${StreamChat.of(context).currentUser}");
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.chat),
      body: RefreshIndicator(
        color: AppColors.buttonColor,
        onRefresh: () async {
          _listController.refresh();
        },
        child: StreamChannelListView(
          separatorBuilder: (context, values, index) {
            return Divider(endIndent: 10, indent: 10, color: AppColors.black.withOpacity(0.35));
          },
          // itemBuilder: (context, items, index, defaultWidget) {
          //   return Padding(
          //     padding: const EdgeInsets.all(5),
          //     child: defaultWidget.copyWith(
          //       leading: ClipRRect(
          //         borderRadius: BorderRadius.circular(50),
          //         child: Container(
          //           clipBehavior: Clip.hardEdge,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(50),
          //             border: Border.all(color: AppColors.buttonColor, width: 3),
          //           ),
          //           child: getNetworkImage(
          //             url: items[index].image ?? "",
          //             borderRadius: 50,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //       title: Text(items[index].name ?? "", style: black18bold),
          //     ),
          //   );
          // },
          controller: _listController,
          onChannelTap: (channel) async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return StreamChannel(channel: channel, child: ChannelPage(channel: channel));
              },
            ));
            // Get.to(() => StreamChannel(channel: channel, child: const ChannelPage()));
          },
        ),
      ),
    );
  }
}

class ChannelPage extends StatefulWidget {
  const ChannelPage({Key? key, required this.channel}) : super(key: key);
  final Channel channel;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Future.delayed(const Duration(seconds: 2)).then((value) {
    //     setState(() {});
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: const <Widget>[
          Expanded(
              child: StreamMessageListView(
                  // messageBuilder: (p0, p1, p2, defaultMessageWidget) {
                  //   return Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       InkWell(
                  //         onLongPress: () {
                  //           if (defaultMessageWidget.onThreadTap != null) {
                  //             defaultMessageWidget.onThreadTap!(p1.message);
                  //           }
                  //         },
                  //         child: Container(
                  //           alignment: Alignment.topRight,
                  //           // width: 250,
                  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10).copyWith(bottomRight: const Radius.circular(0)),
                  //             gradient: AppColors.purpleGradient,
                  //           ),
                  //           child: Text(p1.message.text ?? "", style: white14w500),
                  //         ),
                  //       ),
                  //     ],
                  //   );
                  // },
                  )),
          StreamMessageInput(
              // idleSendButton: Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 10),
              //   padding: const EdgeInsets.all(7),
              //   decoration: BoxDecoration(gradient: AppColors.purpleGradient, borderRadius: BorderRadius.circular(10)),
              //   child: Image.asset(Assets.iconsSendIcon, scale: 3.5),
              // ),
              ///
              // sendButtonBuilder: (context, messageInputController) {
              //   return Container(
              //     margin: const EdgeInsets.symmetric(horizontal: 10),
              //     padding: const EdgeInsets.all(7),
              //     decoration: BoxDecoration(gradient: AppColors.purpleGradient, borderRadius: BorderRadius.circular(10)),
              //     child: Image.asset(Assets.iconsSendIcon, scale: 3.5),
              //   );
              // },
              ),
        ],
      ),
    );
  }
}
