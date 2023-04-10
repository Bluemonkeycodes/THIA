import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thia/modules/chat_module/views/change_image_screen.dart';
import 'package:thia/modules/home_module/model/class_user_model.dart';
import 'package:thia/utils/utils.dart';

class CreatedGroupScreen extends StatefulWidget {
  const CreatedGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreatedGroupScreen> createState() => _CreatedGroupScreenState();
}

class _CreatedGroupScreenState extends State<CreatedGroupScreen> {
  OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)), borderRadius: BorderRadius.circular(15.0));
  final nameController = TextEditingController();
  final searchController = TextEditingController();

  RxList<ClassUserModelData> selectedUserList = <ClassUserModelData>[].obs;
  RxList<ClassUserModelData> searchUserList = <ClassUserModelData>[].obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString imageUrl = kHomeController.getGroupPlaceHolder().obs;

  @override
  void initState() {
    super.initState();
    kChatController.getAllUser({}, () {
      kChatController.allUserList.forEach((element) {
        searchUserList.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, AppTexts.createGroup),
      bottomNavigationBar: GetButton(
        text: AppTexts.createGroup,
        ontap: () async {
          hideKeyBoard(context);
          if (formKey.currentState?.validate() == true) {
            if (selectedUserList.length < 2 || false) {
              showSnackBar(title: ApiConfig.error, message: "Please select at-least 2 users to create group");
            } else {
              List<String> users = selectedUserList.map((element) => (element.userID ?? 0).toString()).toList();
              users.add((kHomeController.userData.value.userId ?? "").toString());
              await chatButtonClick(
                context,
                name: nameController.text,
                id: "custom-${nameController.text.hashCode.toString()}",
                image: imageUrl.value,
                userIdList: users,
                removeRoute: true,
              );
            }
          }
        },
        margin: 15,
        borderRadius: 15,
        gradient: AppColors.purpleGradient,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15),
          children: [
            heightBox(height: 20),
            Center(
              child: StreamBuilder<Object>(
                  stream: imageUrl.stream,
                  builder: (context, snapshot) {
                    return Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(65)),
                          child: getNetworkImage(
                            url: imageUrl.value,
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
                              // changeImage();
                              Get.to(() => ChangeImageScreen(image: imageUrl.value))?.then((value) {
                                showLog("return image ===> $value");
                                imageUrl.value = value.toString();
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
                    );
                  }),
            ),
            GetTextField(
                hintText: AppTexts.enterGroupName,
                title: AppTexts.groupName,
                outlineInputBorder: border,
                textEditingController: nameController,
                validationFunction: (val) {
                  return emptyFieldValidation(val);
                }),
            heightBox(height: 15),
            GetTextField(
              hintText: AppTexts.enterUserName,
              title: AppTexts.searchUserName,
              outlineInputBorder: border,
              textEditingController: searchController,
              onChangedFunction: (String val) {
                onSearchTextChanged(val);
              },
            ),
            heightBox(height: 15),
            Text(AppTexts.selectUser, style: black16w500),
            heightBox(),
            StreamBuilder<Object>(
                stream: searchUserList.stream,
                builder: (context, snapshot) {
                  return ListView.separated(
                    itemCount: searchUserList.length,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) => Divider(endIndent: 10, indent: 10, color: AppColors.black.withOpacity(0.35)),
                    itemBuilder: (context, index) {
                      return userTile(searchUserList[index]);
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      return;
    }
    searchUserList.clear();

    kChatController.allUserList.forEach((userDetail) {
      if ((userDetail.firstname ?? "").toLowerCase().contains(text.toLowerCase()) || (userDetail.lastname ?? "").toLowerCase().contains(text.toLowerCase())) {
        searchUserList.add(userDetail);
      }
    });
  }

  Widget userTile(ClassUserModelData data) {
    return StreamBuilder<Object>(
        stream: selectedUserList.stream,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              if (selectedUserList.contains(data)) {
                selectedUserList.remove(data);
              } else {
                selectedUserList.add(data);
              }
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
                        // border: Border.all(color: AppColors.buttonColor, width: 3),
                      ),
                      child: getNetworkImage(
                        url: data.profileUrl ?? "",
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
                        Text("${data.firstname ?? ""} ${data.lastname ?? ""}", style: black18bold),
                        heightBox(),
                      ],
                    ),
                  ),
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: selectedUserList.contains(data),
                    onChanged: (val) {
                      if (selectedUserList.contains(data)) {
                        selectedUserList.remove(data);
                      } else {
                        selectedUserList.add(data);
                      }
                    },
                    splashRadius: 10.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1, color: AppColors.primaryColor)),
                    checkColor: AppColors.primaryColor,
                    activeColor: Colors.transparent,
                    hoverColor: AppColors.primaryColor,
                  )
                ],
              ),
            ),
          );
        });
  }
}
