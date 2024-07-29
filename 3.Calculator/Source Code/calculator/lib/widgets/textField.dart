import 'package:flutter/material.dart';
import 'package:calculator/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor:
              isDarkMode ? kDarkColorScheme.tertiary : kcolorScheme.tertiary,
          filled: true,
        ),
        style: TextStyle(
            fontSize: 50, color: isDarkMode ? Colors.white : Colors.black),
        readOnly: true,
        autofocus: true,
        showCursor: true,
        cursorColor: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
