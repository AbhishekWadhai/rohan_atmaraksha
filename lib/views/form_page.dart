import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/widgets/dynamic_form.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic pageTitle = Get.arguments[0];
    final dynamic initialData = Get.arguments[1];
    final bool isEditable = Get.arguments[2] ?? false;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(pageTitle),
        //iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: DynamicForm(
        pageName: pageTitle,
        initialData: initialData,
        isEdit: isEditable,
      ),
    );
  }
}
