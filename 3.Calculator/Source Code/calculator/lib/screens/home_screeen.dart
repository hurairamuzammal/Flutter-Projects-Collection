import 'package:calculator/constants/colors.dart';
import 'package:calculator/provider/cal_provider.dart';
import 'package:calculator/widgets/calculate_button.dart';
import 'package:flutter/material.dart';
import 'package:calculator/widgets/textField.dart';
import 'package:calculator/screens/widget_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void showHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        bool isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        return Container(
          color: isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
          padding: EdgeInsets.all(20),
          child: Consumer<CalculatorProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  Text(
                    "History",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w300,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      provider.box?.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Clear History",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.box?.length ?? 0,
                      itemBuilder: (context, index) {
                        final history = provider.box?.getAt(index);
                        return ListTile(
                          title: Container(
                            color: isDarkMode
                                ? kDarkColorScheme.tertiary
                                : kcolorScheme.tertiary,
                            child: Text(
                              history ?? '',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = EdgeInsets.symmetric(horizontal: 25, vertical: 30);
    final decoration = BoxDecoration(
      color: isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    );

    return Consumer<CalculatorProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Calculator"),
          backgroundColor:
              isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          actions: [
            IconButton(icon: Icon(Icons.history), onPressed: showHistory),
          ],
        ),
        backgroundColor:
            isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
        body: Column(
          children: [
            CustomTextField(controller: provider.compController),
            const Spacer(),
            Container(
              height: screenHeight * 0.6,
              width: double.infinity,
              padding: padding,
              decoration: decoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => buttonList[index]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        List.generate(4, (index) => buttonList[index + 4]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        List.generate(4, (index) => buttonList[index + 8]),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  3, (index) => buttonList[index + 12]),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  3, (index) => buttonList[index + 15]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      CalculateButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
