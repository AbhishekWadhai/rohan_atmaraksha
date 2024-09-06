import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/routes/routes.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/services/jwt_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await isTokenValid();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      initialRoute: isLoggedIn ? Routes.homePage : Routes.loginPage,
      getPages: AppRoutes.routes,
    );
  }
}
