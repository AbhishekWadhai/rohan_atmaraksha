import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class SoraPage extends StatelessWidget {
  const SoraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Center(
        child: TextButton(
          child: const Text("SORA"),
          onPressed: () {
            Get.toNamed(Routes.homePage);
          },
        ),
      ),
    );
  }
}
