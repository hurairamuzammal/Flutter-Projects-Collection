import 'package:flutter/material.dart';
import 'package:converter/converter_app.dart';

var kcolorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 201, 201, 201),
).copyWith(
  secondary: const Color.fromARGB(255, 30, 30, 30),
  primary: const Color.fromARGB(255, 255, 255, 255),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 41, 40, 40),
).copyWith(
  secondary: const Color.fromARGB(255, 255, 255, 255),
  primary: const Color.fromARGB(255, 30, 30, 30),
);

void main() => runApp(const MyApp());
