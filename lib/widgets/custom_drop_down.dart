import 'package:flutter/material.dart';
import 'package:task_manger/config/constant.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.hint,
    required this.icon,
    this.onChanged,
  });

  final List<String> categories;
  final String hint;
  final IconData icon;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: null,
      hint: Text(hint, style: TextStyle(color: Colors.grey)),
      decoration: InputDecoration(
        fillColor: Color(0xffF5F5F5),
        filled: true,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      items: categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
