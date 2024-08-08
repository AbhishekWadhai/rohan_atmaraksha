import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/controller/work_permit_controller.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/dynamic_form.dart';

import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class WorkPermitPage extends StatelessWidget {
  final workPermitController = Get.put(WorkPermitController());
  WorkPermitPage({super.key});

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
        drawer: const MyDrawer(),
        body: Stack(
          children: [
            Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.workPermitForm);
                    },
                    icon: const Icon(Icons.add_circle))),
            DynamicForm(pageName: "Home"),
          ],
        ));
  }
}
