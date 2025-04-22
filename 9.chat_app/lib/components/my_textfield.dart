import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obsure;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obsure,
    required this.controller,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        obscureText: obsure,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
