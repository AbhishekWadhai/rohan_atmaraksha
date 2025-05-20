import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
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
        appBarTheme: AppBarTheme(
            backgroundColor: AppColors.appMainDark,
            foregroundColor: Colors.white),
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appMainDark),
        useMaterial3: false,
      ),
      initialRoute: isLoggedIn ? Routes.homePage : Routes.loginPage,
      getPages: AppRoutes.routes,
    );
  }
}
