import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.fieldName,
    required this.controller,
    this.labelText = '',
    this.isPassword = false,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final String fieldName;
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: const TextStyle(fontWeight: FontWeight.bold),),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
