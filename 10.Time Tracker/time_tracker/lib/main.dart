import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/home_screen.dart';
import 'package:time_tracker/project_task_provider.dart';
import 'package:time_tracker/time_entry_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
