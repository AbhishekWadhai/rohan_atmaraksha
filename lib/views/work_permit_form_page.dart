import 'package:flutter/material.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/forms/work_permit_form.dart';

class WorkPermitFormPage extends StatelessWidget {
  const WorkPermitFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(Strings.workPermit),
        //iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: WorkPermitForm(),
    );
  }
}
