import 'dart:convert';

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
  var isPasswordHidden = true.obs;

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
          Get.offAllNamed(Routes.homePage);
        } else {
          Get.snackbar("Login Failed", "Enter valid credentials",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
        print(a);
      } catch (e) {
        Get.snackbar("Login Failed",
            "Enter valid credentials, Or Check your Internet Connection",
            duration: Duration(seconds: 10),
            backgroundColor: Colors.red,
            colorText: Colors.white);
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

class ForgotPasswordController extends GetxController {
  var email = ''.obs;
  var otp = ''.obs;
  var newPassword = ''.obs;
  var isOtpSent = false.obs;
  var isLoading = false.obs;

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  void sendOtp() async {
    isLoading.value = true;
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email',
          backgroundColor: Colors.yellow, colorText: Colors.white);
      isLoading.value = false;
      return;
    } else {
      try {
        await ApiService().postRequest(
            "user/forgot-password", {"emailId": emailController.text});
        isOtpSent.value = true;
        isLoading.value = false;
        Get.snackbar('Success', 'OTP sent to your email',
            backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', 'Unable to send OTP',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  void resetPassword() async {
    if (otpController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP and new password',
          backgroundColor: Colors.yellow, colorText: Colors.white);
      return;
    } else {
      Map<String, String> data = {
        "emailId": emailController.text,
        "otp": otpController.text,
        "newPassword": passwordController.text,
      };
      try {
        isLoading.value = true;

        await ApiService().postRequest("user/reset-password", data);
        print(jsonEncode(data));
        isLoading.value = false;
        Get.back(); // Close dialog
        Get.snackbar('Success', 'Password has been reset',
            backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        print(jsonEncode(data));
        print("_________________$e");
        isLoading.value = false;
        Get.snackbar('Error', 'Unable to Change Password',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }

    // TODO: Replace this with actual API call
  }
}
