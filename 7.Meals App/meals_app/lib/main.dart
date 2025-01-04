import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals_app/screens/tabs.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 247, 223, 206),
    surface: const Color.fromARGB(255, 247, 223, 206),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const 
  ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});
  isDarkMode(BuildContext context) {
    if (MediaQuery.platformBrightnessOf(context) == Brightness.dark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = isDarkMode(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
