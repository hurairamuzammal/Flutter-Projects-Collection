import 'package:flutter/material.dart';
import 'package:stopwatch/home_screen.dart';
import 'package:stopwatch/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        primaryColor: kDarkColorScheme.primary,
        textTheme: textTheme,
      ),
      theme: ThemeData().copyWith(
        colorScheme: kcolorScheme,
        primaryColor: kcolorScheme.primary,
        textTheme: textTheme,
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
