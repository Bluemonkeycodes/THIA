import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/utils/utils.dart';

class ChangeImageScreen extends StatefulWidget {
  const ChangeImageScreen({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  State<ChangeImageScreen> createState() => _ChangeImageScreenState();
}

class _ChangeImageScreenState extends State<ChangeImageScreen> {
  RxString selectedImage = "".obs;

  @override
  void initState() {
    super.initState();
    selectedImage.value = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(
        context,
        "Select Image",
        actionWidgets: [
          IconButton(
            onPressed: () {
              Get.back(result: selectedImage.value);
            },
            icon: Icon(Icons.check, color: AppColors.black),
          ),
        ],
      ),
      body: StreamBuilder<Object>(
          stream: selectedImage.stream,
          builder: (context, snapshot) {
            return GridView.builder(
              itemCount: kHomeController.groupPlaceholderImageList.length,
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectedImage.value = kHomeController.groupPlaceholderImageList[index];
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      getNetworkImage(
                        url: kHomeController.groupPlaceholderImageList[index],
                        borderRadius: 10,
                      ),
                      if (kHomeController.groupPlaceholderImageList[index] == selectedImage.value)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.check_circle, color: AppColors.primaryColor),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
