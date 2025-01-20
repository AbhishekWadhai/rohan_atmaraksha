import 'package:flutter/material.dart';

class TextStyles {
  static const TextDecoration underline = TextDecoration.underline;
  static const TextDecoration lineThrough = TextDecoration.lineThrough;

  static TextStyle get drawerTextStyle => const TextStyle(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal);

  static TextStyle get appBarTextStyle => const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle get appBarSubTextStyle => const TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black);
}
