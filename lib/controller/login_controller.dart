import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';
import 'package:rohan_suraksha_sathi/services/connection_service.dart';
import 'package:rohan_suraksha_sathi/services/jwt_service.dart';
import 'package:rohan_suraksha_sathi/services/shared_preferences.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String fcmToken = Strings.fcmToken;
  var isLoading = false.obs;

  onInit() {
    super.onInit();
    ConnectivityService.checkAndShowOfflineSnackbar();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void handleLogin() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      // If the form is valid, display a snackbar and navigate
      try {
        final a = await ApiService().postRequest("user/login", {
          "emailId": usernameController.text,
          "password": passwordController.text,
          "fcmToken": fcmToken
        });
        if (a != null) {
          await SharedPrefService().saveString("token", a["token"]);
          await isTokenValid();
          Get.toNamed(Routes.homePage);
        } else {
          Get.snackbar("Login Failed", "Enter valid credentials",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
        print(a);
      } catch (e) {
        Get.snackbar("Login Failed", "Enter valid credentials, Or Check your Internet Connection",duration: Duration(seconds: 10),
              backgroundColor: Colors.red, colorText: Colors.white);
        print(e);
      } finally {}
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
