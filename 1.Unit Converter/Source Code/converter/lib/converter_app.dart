import 'package:converter/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:converter/button.dart'; // Make sure this import is correct and the file exists

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _startMeasure = 'meters';
  String _convertedMeasure = 'kilometers';
  double _numberForm = 0.0;
  String _resultMessage = "";

  final List<String> _measures = const [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
    'celsius',
    'fahrenheit',
  ];

  final Map<String, int> _measuresMap = const {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
    'celsius': 8,
    'fahrenheit': 9,
  };

  final dynamic _formulas = const {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0, 0, 0],
    '2': [0, 0, 1, 0.001, 0, 0, 0.00220462, 0.035274, 0, 0],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274, 0, 0],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16, 0, 0],
    '7': [0, 0, 28.3495, 0.0283495, 0, 0, 0.0625, 1, 0, 0],
    '8': [0, 0, 0, 0, 0, 0, 0, 0, 1, 33.8],
    '9': [0, 0, 0, 0, 0, 0, 0, 0, -17.2222, 1],
  };

  void convert(double value, String from, String to) {
    int? nFrom = _measuresMap[from];
    int? nTo = _measuresMap[to];
    double result = 0;

    if (nFrom != null && nTo != null) {
      if ((nFrom == 8 && nTo == 9) || (nFrom == 9 && nTo == 8)) {
        // Special case for Celsius and Fahrenheit conversion
        if (nFrom == 8 && nTo == 9) {
          // Celsius to Fahrenheit
          result = (value * 9 / 5) + 32;
        } else {
          // Fahrenheit to Celsius
          result = (value - 32) * 5 / 9;
        }
      } else {
        var multiplier = _formulas[nFrom.toString()][nTo];
        result = value * multiplier;
      }
      // round of the result to max 2 decimal places
      result = double.parse(result.toStringAsFixed(4));

      if (result == 0) {
        _resultMessage = 'This conversion cannot be performed';
      } else {
        _resultMessage =
            '${_numberForm.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';
      }
    } else {
      _resultMessage = 'Invalid conversion';
    }

    setState(() {
      _resultMessage = _resultMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final TextStyle inputStyle = TextStyle(
      fontSize: 18,
      color: isDarkMode ? Colors.white : Colors.black87,
    );

    final TextStyle labelStyle = GoogleFonts.anton(
      fontSize: 35,
      fontWeight: FontWeight.w300,
      color: isDarkMode ? Colors.white : Colors.black,
    );

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
      debugShowCheckedModeBanner: false,
      title: 'Quick Converter',
      home: Scaffold(
        backgroundColor:
            isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Quick Unit Converter'),
          backgroundColor:
              isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
          foregroundColor:
              isDarkMode ? kDarkColorScheme.secondary : kcolorScheme.secondary,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                style: inputStyle,
                decoration: const InputDecoration(
                  hintText: "Please enter the value",
                ),
                onChanged: (text) {
                  var rv = double.tryParse(text);
                  if (rv != null) {
                    setState(() {
                      _numberForm = rv;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    style: inputStyle,
                    hint: Text(
                      "Unit",
                      style: inputStyle,
                    ),
                    items: _measures.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _startMeasure = value!;
                      });
                    },
                    value: _startMeasure,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.blue[600],
                    size: 35.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    hint: Text(
                      "Unit",
                      style: inputStyle,
                    ),
                    style: inputStyle,
                    items: _measures.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: inputStyle,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _convertedMeasure = value!;
                      });
                    },
                    value: _convertedMeasure,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                _resultMessage,
                style: labelStyle,
              ),
              const Spacer(),
              Mybutton(
                onTab: () {
                  if (_numberForm == 0) {
                    return;
                  } else {
                    convert(_numberForm, _startMeasure, _convertedMeasure);
                  }
                },
                textS: "Convert",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
