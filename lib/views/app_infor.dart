// controllers/package_info_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoController extends GetxController {
  var appName = ''.obs;
  var packageName = ''.obs;
  var version = ''.obs;
  var buildNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPackageInfo();
  }

  Future<void> loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    appName.value = info.appName;
    packageName.value = info.packageName;
    version.value = info.version;
    buildNumber.value = info.buildNumber;
  }
}
// views/package_info_page.dart

class PackageInfoPage extends StatelessWidget {
  final controller = Get.put(PackageInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("App Name: ${controller.appName.value}"),
                Text("Package Name: ${controller.packageName.value}"),
                Text("Version: ${controller.version.value}"),
                Text("Build Number: ${controller.buildNumber.value}"),
              ],
            )),
      ),
    );
  }
}
