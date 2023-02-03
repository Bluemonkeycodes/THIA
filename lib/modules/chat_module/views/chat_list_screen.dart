import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import 'messages_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.chat),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) {
          return Divider(
            endIndent: 10,
            indent: 10,
            color: AppColors.black.withOpacity(0.35),
          );
        },
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              hideKeyBoard(context);
              Get.to(() => const MessagesScreen());
            },
            child: Padding(
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
                        border: Border.all(color: AppColors.buttonColor, width: 3),
                      ),
                      child: getNetworkImage(
                        url:
                            "https://images.unsplash.com/photo-1669993427100-221137cc7513?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDYxfHRvd0paRnNrcEdnfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=900&q=60",
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
                        Text("Math - John Sir", style: black18bold),
                        heightBox(),
                        Text("Hello...", style: black12w500),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Just Now", style: grey12w500),
                      heightBox(),
                      Container(
                          height: 23,
                          width: 23,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: AppColors.purpleGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text("2", style: white12w500),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
