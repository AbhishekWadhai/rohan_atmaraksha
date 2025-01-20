import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';

class SafetyCheckPage extends StatelessWidget {
  const SafetyCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Center(
        child: TextButton(
          child: const Text("Safety Check"),
          onPressed: () {
            Get.toNamed(Routes.homePage);
          },
        ),
      ),
    );
  }
}
