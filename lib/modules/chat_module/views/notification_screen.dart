import 'package:flutter/material.dart';
import 'package:thia/utils/utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    kChatController.getAllNotification({}, () => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.notification),
      body: StreamBuilder<Object>(
          stream: kChatController.allNotificationList.stream,
          builder: (context, snapshot) {
            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                kChatController.getAllNotification({}, () => null);
              },
              child: kChatController.allNotificationList.isEmpty
                  ? noDataFoundWidget(message: "No notification")
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(15),
                      itemCount: kChatController.allNotificationList.length,
                      separatorBuilder: (context, index) => heightBox(height: 15),
                      itemBuilder: (context, index) {
                        return Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getNetworkImage(
                              url: kChatController.allNotificationList[index].channelImage ?? "",
                              borderRadius: 50,
                              height: 80,
                              width: 80,
                            ),
                            widthBox(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      textAlign: TextAlign.start,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        TextSpan(text: kChatController.allNotificationList[index].inviteBy ?? "", style: black16w700),
                                        TextSpan(text: " invited you to ", style: black16w500),
                                        TextSpan(text: kChatController.allNotificationList[index].channelName ?? "", style: black16w700),
                                      ])),
                                  heightBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GetButton(
                                          text: AppTexts.accept,
                                          ontap: () {
                                            kChatController.acceptNotification(
                                              (kChatController.allNotificationList[index].nid ?? 0).toString(),
                                              () async {
                                                await chatButtonClick(
                                                  context,
                                                  id: kChatController.allNotificationList[index].channelId ?? "",
                                                  userIdList: [(kHomeController.userData.value.userId ?? "").toString()],
                                                  removeRoute: true,
                                                );
                                              },
                                            );
                                          },
                                          height: 40,
                                          backGroundColor: AppColors.primaryColor,
                                          textStyle: white16w500,
                                        ),
                                      ),
                                      widthBox(),
                                      Expanded(
                                        child: GetButton(
                                          text: AppTexts.decline,
                                          ontap: () {
                                            kChatController.rejectNotification(
                                              (kChatController.allNotificationList[index].nid ?? 0).toString(),
                                              () {},
                                            );
                                          },
                                          height: 40,
                                          backGroundColor: AppColors.black.withOpacity(0.1),
                                          textStyle: black16w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            );
          }),
    );
  }
}
