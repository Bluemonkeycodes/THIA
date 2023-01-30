import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thia/generated/assets.dart';
import 'package:thia/utils/utils.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, "Math - John Sir"),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 20,
              separatorBuilder: (context, index) {
                return heightBox();
              },
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      // width: 250,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).copyWith(bottomRight: const Radius.circular(0)),
                        gradient: AppColors.purpleGradient,
                      ),
                      child: Text("Hello, how are you...", style: white14w500),
                    )
                  ],
                );
              },
            ),
          ),
          heightBox(),
          Row(
            children: [
              widthBox(),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(gradient: AppColors.purpleGradient, borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.photo_outlined,
                  color: AppColors.white,
                ),
              ),
              widthBox(),
              Expanded(
                child: GetTextField(hintText: "Message...", filledColor: AppColors.black.withOpacity(0.04), height: 45),
              ),
              widthBox(),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(gradient: AppColors.purpleGradient, borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  Assets.iconsSendIcon,
                  scale: 3.5,
                ),
              ),
              widthBox(),
            ],
          )
        ],
      ),
    );
  }
}
