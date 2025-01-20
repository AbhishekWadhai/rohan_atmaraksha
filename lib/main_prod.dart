import 'package:flutter/material.dart';
import 'package:rohan_suraksha_sathi/env.dart';
import 'package:rohan_suraksha_sathi/main.dart';
import 'package:rohan_suraksha_sathi/services/jwt_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await isTokenValid();
  AppEnvironment.setupEnv(Environment.prod);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}
