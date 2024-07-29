import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo/screens/login.dart';

var kcolorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 201, 201, 201),
).copyWith(
    secondary: const Color.fromARGB(255, 30, 30, 30),
    primary: const Color.fromARGB(255, 255, 255, 255));

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 41, 40, 40),
).copyWith(
  secondary: const Color.fromARGB(255, 255, 255, 255),
  primary: const Color.fromARGB(255, 30, 30, 30),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        primaryColor: kDarkColorScheme.primary,
      ),
      theme: ThemeData().copyWith(
        colorScheme: kcolorScheme,
        primaryColor: kcolorScheme.primary,
      ),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
