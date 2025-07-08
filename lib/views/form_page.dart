import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';

import 'package:rohan_suraksha_sathi/services/translation.dart';
import 'package:rohan_suraksha_sathi/widgets/custom_alert_dialog.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form.dart';
import 'package:rohan_suraksha_sathi/widgets/helper_widgets/flexibleText.dart';

class FormPage extends StatelessWidget {
  FormPage({super.key});
  final DynamicFormController controller = Get.put(DynamicFormController());
  @override
  Widget build(BuildContext context) {
    final dynamic pageTitle = Get.arguments[0];
    final dynamic initialData = Get.arguments[1];
    final bool isEditable = Get.arguments[2] ?? false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_rounded)),

        title: FlexibleText(
          text: translate(pageTitle),
          baseFontSize: 22,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //Text(translate(pageTitle), style: TextStyle(fontSize: ),),
        //iconTheme: const IconThemeData(color: Colors.black),

        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              Get.dialog(CustomAlertDialog(
                visual: const Icon(Icons.refresh_rounded,
                    color: AppColors.appMainMid),
                title: 'Confirm Refresh',
                description:
                    'This will fetch the latest dropdown data.\nPress "Yes" to continue?',
                buttons: [
                  CustomDialogButton(
                    label: 'Cancel',
                    onPressed: () => Get.back(),
                  ),
                  CustomDialogButton(
                    color: AppColors.appMainMid,
                    label: 'Yes',
                    isPrimary: true,
                    onPressed: () {
                      Get.back();
                      controller.refreshDropdownData();
                    },
                  ),
                ],
              ));
            },
          ),
          IconButton(
            onPressed: () {
              controller.isSaved.value = !controller.isSaved.value;
            },
            icon: Obx(() => Icon(
                  controller.isSaved.value
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                )),
          )
        ],
      ),
      body: DynamicForm(
        pageName: pageTitle,
        initialData: initialData,
        isEdit: isEditable,
      ),
    );
  }
}
