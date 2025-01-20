import 'package:flutter/material.dart';

enum Environment { dev, prod }

abstract class AppEnvironment {
  static late String baseUrl;
  static late String title;
  static late Color appBarColor;
  static late Environment _environment;
  static Environment get environment => _environment;
  static setupEnv(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.dev:
        {
          baseUrl = 'https://rohan-sage.vercel.app';
          title = 'Welcome To Suraksha Saathi!';
          appBarColor = Colors.blue;
          break;
        }
      case Environment.prod:
        {
          baseUrl = 'https://rohan-testing.vercel.app';
          title = 'Welcome To Suraksha Saathi!';
          appBarColor = Colors.blue;
          break;
        }
    }
  }
}
