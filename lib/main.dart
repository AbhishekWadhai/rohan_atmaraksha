import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/routes/routes.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[700]!),
        useMaterial3: false,
      ),
      initialRoute: isLoggedIn ? Routes.homePage : Routes.loginPage,
      getPages: AppRoutes.routes,
    );
  }
}
