import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class IncidentReportPage extends StatelessWidget {
  const IncidentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Center(
        child: TextButton(
          child: const Text("Incident Report"),
          onPressed: () {
            Get.toNamed(Routes.homePage);
          },
        ),
      ),
    );
  }
}
