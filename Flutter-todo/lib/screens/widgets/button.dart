import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final VoidCallback onTab;
  final String textS;

  const Mybutton({
    super.key,
    required this.onTab,
    required this.textS,
  });

  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTab,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            width: double.infinity,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                textS,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ));
  }
}
