import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kcolorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 255, 255),
).copyWith(
    secondary: const Color.fromARGB(255, 31, 30, 30),
    primary: const Color.fromARGB(255, 255, 255, 255));

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 41, 40, 40),
).copyWith(
  secondary: const Color.fromARGB(255, 255, 255, 255),
  primary: const Color.fromARGB(255, 31, 30, 30),
);

TextTheme textTheme = GoogleFonts.bebasNeueTextTheme();
