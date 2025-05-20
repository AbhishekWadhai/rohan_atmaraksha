import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/services/load_dropdown_data.dart';
import 'package:rohan_suraksha_sathi/services/translation.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form.dart';
import 'package:rohan_suraksha_sathi/widgets/helper_widgets/flexibleText.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

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
          PopupMenuButton(
              icon: const Icon(Icons.more_vert), // Three-dot icon
              onSelected: (value) async {
                if (value == 'refresh') {
                  // Call the refresh logic here
                  await loadDropdownData();
                  // You can pass this refresh action to the controller or a function in DynamicForm
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'refresh',
                    child: Text('Refresh'),
                  ),
                  // Add more menu options here if needed
                ];
              })
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
