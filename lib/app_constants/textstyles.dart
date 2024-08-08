import 'package:flutter/material.dart';

class TextStyles {
  static const TextDecoration underline = TextDecoration.underline;
  static const TextDecoration lineThrough = TextDecoration.lineThrough;

  static TextStyle get drawerTextStyle => const TextStyle(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);

  static TextStyle get appBarTextStyle => const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
}
