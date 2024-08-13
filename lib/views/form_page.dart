import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/widgets/dynamic_form.dart';

class WorkPermitFormPage extends StatelessWidget {
  
  const WorkPermitFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String pageTitle = Get.arguments['pageTitle'];
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(pageTitle),
        //iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: DynamicForm(pageName: "workpermit"),
    );
  }
}
