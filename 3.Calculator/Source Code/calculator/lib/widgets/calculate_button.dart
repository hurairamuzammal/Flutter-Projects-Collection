import 'package:calculator/constants/colors.dart';
import 'package:calculator/provider/cal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculateButton extends StatelessWidget {
  const CalculateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<CalculatorProvider>(context, listen: false).setVal("=");
      },
      child: Container(
        height: 160,
        width: 70,
        decoration: BoxDecoration(
          color: kcolorScheme.secondary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            "=",
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
