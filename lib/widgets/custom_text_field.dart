import 'package:flutter/material.dart';
import 'package:task_manger/config/constant.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.preIcon,
    this.isPassword = false,
    this.sufIcon,
    this.validator,
    this.controller,
    this.textInputType,
  });

  final String hint;
  final IconData preIcon;
  final bool isPassword;
  final IconButton? sufIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: textInputType,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter $hint";
            }
            return null;
          },
      decoration: InputDecoration(
        suffixIcon: sufIcon,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(preIcon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kPrimaryColor, width: 2),
        ),
      ),
    );
  }
}
