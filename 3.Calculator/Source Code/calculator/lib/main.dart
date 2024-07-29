import 'package:calculator/provider/cal_provider.dart';
import 'package:flutter/material.dart';
import 'package:calculator/screens/home_screeen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:calculator/constants/colors.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('calculationHistory');
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(CalculatorApp());
  });
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorProvider(),
      child: MaterialApp(
        title: 'Calculator App',
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          primaryColor: kDarkColorScheme.primary,
        ),
        theme: ThemeData().copyWith(
          colorScheme: kcolorScheme,
          primaryColor: kcolorScheme.primary,
        ),
        themeMode: ThemeMode.system,
        home: HomeScreen(),
      ),
    );
  }
}
