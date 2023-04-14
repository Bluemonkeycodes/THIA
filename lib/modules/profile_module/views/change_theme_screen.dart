import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/utils/utils.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({Key? key}) : super(key: key);

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  RxInt darkLightIndex = 1.obs;
  RxInt selectedColorIndex = 0.obs;

  RxList<Color> lightColorList = <Color>[
    const Color(0xff6C6DEE),
    const Color(0xff2A3950),
    const Color(0xff266baf),
    const Color(0xff2C6668),
    const Color(0xffFDB096),
  ].obs;

  RxList<Color> darkColorList = <Color>[
    const Color(0xffCE467B),
    const Color(0xff8C6DC7),
    const Color(0xff499B9E),
    const Color(0xff526FDA),
    const Color(0xffA32CB6),
  ].obs;

  RxList<Color> getColorList() {
    return darkLightIndex.value == 1 ? lightColorList : darkColorList;
  }

  @override
  void initState() {
    super.initState();
    darkLightIndex.value = getDarkMode() ? 2 : 1;
    selectedColorIndex.value = getColorList().indexOf(AppColors.primaryColor);
  }

  Color whiteColor = const Color(0xffffffff);
  Color blackColor = const Color(0xff000000);
  Color backgroundColor = const Color(0xff181A20).withOpacity(0.9);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: selectedColorIndex.stream,
        builder: (context, snapshot) {
          return StreamBuilder<Object>(
              stream: darkLightIndex.stream,
              builder: (context, snapshot) {
                return Scaffold(
                  appBar: GetAppBar(
                    context,
                    AppTexts.changeTheme,
                    bgColor: darkLightIndex.value == 1 ? whiteColor : backgroundColor,
                    titleStyle: black20w600.copyWith(color: darkLightIndex.value == 1 ? blackColor : whiteColor),
                    leadingColor: darkLightIndex.value == 1 ? blackColor : whiteColor,
                  ),
                  backgroundColor: darkLightIndex.value == 1 ? whiteColor : backgroundColor,
                  bottomNavigationBar: GetButton(
                    ontap: () async {
                      setDarkMode(!(darkLightIndex.value == 1));
                      setPrimaryColor(getColorList()[selectedColorIndex.value].value);

                      showLog("getDarkMode ===> ${getDarkMode()}");
                      showLog("primary color is ===> ${getPrimaryColor().toString()}");
                      //TODO: restart app here
                      await StreamChat.of(context).client.disconnectUser().then((value) async {
                        await Get.deleteAll(force: true);
                        Phoenix.rebirth(Get.context!);
                        Get.reset();
                      });
                    },
                    text: AppTexts.apply,
                    margin: 15,
                    borderRadius: 15,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [getColorList()[selectedColorIndex.value], getColorList()[selectedColorIndex.value].withOpacity(0.6)],
                    ),
                    textStyle: white18w600.copyWith(color: darkLightIndex.value == 1 ? whiteColor : blackColor),
                  ),
                  body: ListView(
                    padding: const EdgeInsets.all(15),
                    children: [
                      Text("Select Theme:", style: black16w600.copyWith(color: darkLightIndex.value == 1 ? blackColor : whiteColor)),
                      heightBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: darkLightButton(1)),
                          widthBox(),
                          Expanded(child: darkLightButton(2)),
                        ],
                      ),
                      heightBox(height: 15),
                      Divider(color: darkLightIndex.value == 1 ? blackColor : whiteColor),
                      heightBox(height: 15),
                      Text("Select Color:", style: black16w600.copyWith(color: darkLightIndex.value == 1 ? blackColor : whiteColor)),
                      heightBox(height: 20),
                      Wrap(
                        children: getColorList().map((element) => colorBox(element, getColorList().indexOf(element))).toList(),
                      ),
                      heightBox(height: 5),
                      Divider(color: darkLightIndex.value == 1 ? blackColor : whiteColor),
                      heightBox(height: 15),
                      Text("Actual view:", style: black16w600.copyWith(color: darkLightIndex.value == 1 ? blackColor : whiteColor)),
                      heightBox(height: 20),
                      actualViewSection(),
                    ],
                  ),
                );
              });
        });
  }

  Widget actualViewSection() {
    Color x = getColorList()[selectedColorIndex.value];
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        itemCount: 2,
        shrinkWrap: true,
        primary: false,
        separatorBuilder: (context, index) => heightBox(height: 25),
        itemBuilder: (context, index) {
          final image = kHomeController.getGroupPlaceHolder();
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: x.withOpacity(0.1),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: x),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: x.withOpacity(0.6), borderRadius: BorderRadius.circular(50)),
                  child: getNetworkImage(
                    url: image,
                    borderRadius: 50,
                    height: 75,
                    width: 75,
                    fit: BoxFit.contain,
                  ),
                ),
                widthBox(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Math",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: black18w600.copyWith(fontWeight: FontWeight.w700, color: darkLightIndex.value == 1 ? blackColor : whiteColor),
                      ),
                      Divider(color: x, thickness: 1.3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "John Doe",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: grey14w500.copyWith(
                                color: darkLightIndex.value == 1 ? blackColor.withOpacity(0.3) : whiteColor.withOpacity(0.3),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: x,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget colorBox(Color color, int index) {
    return InkWell(
      onTap: () {
        selectedColorIndex.value = index;
      },
      child: Container(
        height: selectedColorIndex.value == index ? 60 : 50,
        width: getScreenWidth(context) / getColorList().length,
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: (selectedColorIndex.value == index) ? Icon(Icons.check_circle_rounded, color: whiteColor) : null,
      ),
    );
  }

  Widget darkLightButton(int index) {
    return InkWell(
      onTap: () {
        darkLightIndex.value = index;
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: index == 1 ? whiteColor : backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: index == darkLightIndex.value ? Border.all(color: getColorList()[selectedColorIndex.value], width: 2) : null,
        ),
        child: Center(
          child: Stack(
            children: [
              if (index == darkLightIndex.value)
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: getColorList()[selectedColorIndex.value],
                  ),
                ),
              Text(
                index == 1 ? "Light" : "Dark",
                style: white16w500.copyWith(color: index == 1 ? blackColor : whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
