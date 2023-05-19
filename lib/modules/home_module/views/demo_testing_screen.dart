import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final searchController = TextEditingController();
  OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)), borderRadius: BorderRadius.circular(15.0));
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetAppBar(context, "Demo", leadingIcon: const SizedBox()),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            GetTextField(
                hintText: "Enter text",
                title: "Enter text",
                outlineInputBorder: border,
                textEditingController: searchController,
                validationFunction: (val) {
                  return emptyFieldValidation(val);
                }),
            heightBox(height: 20),
            GetButton(
              text: "Done",
              ontap: () {
                hideKeyBoard(context);
                if (formKey.currentState?.validate() == true) {
                  kHomeController.demoApi(searchController.text, () {});
                }
              },
            ),
            heightBox(height: 20),
            Text(kHomeController.testModel.value.id ?? ""),
          ],
        ),
      ),
    );
  }
}
