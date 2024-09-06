import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';
import 'package:rohan_atmaraksha/services/shared_preferences.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      // If the form is valid, display a snackbar and navigate
      try {
        final a = await ApiService().postRequest("user/login", {
          "emailId": usernameController.text,
          "password": passwordController.text
        });
        if (a != null) {
          SharedPrefService().saveString("token", a["token"]);
          Get.toNamed(Routes.homePage);
        } else {
          Get.snackbar("Login Failed", "Enter valid credentials",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
        print(a);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
