import 'package:flutter/material.dart';
import 'package:calculator/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:calculator/provider/cal_provider.dart';

class Button1 extends StatelessWidget {
  final String label;
  Color? textColor;
  bool special = false;

  Button1(
      {super.key, required this.label, this.textColor, this.special = false});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (special == false) {
      textColor = isDarkMode ? Colors.white : Colors.black;
    }

    return InkWell(
      onTap: () {
        // animation effect on button press
        Provider.of<CalculatorProvider>(context, listen: false).setVal(label);
      },
      child: Material(
        elevation: 5,
        color: isDarkMode ? kDarkColorScheme.tertiary : kcolorScheme.tertiary,
        borderRadius: BorderRadius.circular(50),
        child: CircleAvatar(
          backgroundColor:
              isDarkMode ? kDarkColorScheme.tertiary : kcolorScheme.tertiary,
          radius: 36,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
