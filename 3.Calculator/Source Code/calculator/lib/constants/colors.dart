import 'package:flutter/material.dart';

var kcolorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 255, 255, 255),
).copyWith(
    secondary: const Color(0xFF317AF7),
    tertiary: Color.fromARGB(240, 240, 240, 240),
    primary: Color.fromRGBO(255, 255, 255, 1));

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 41, 40, 40),
).copyWith(
  tertiary: Color(0xFF262820),
  secondary: Color(0xFF317AF7),
  primary: Color(0xFF212224),
);
