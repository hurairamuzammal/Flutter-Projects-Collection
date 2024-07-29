import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stopwatch/themes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const HomeApp();
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSecond = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List<String> laps = [];
  Duration lastLapTime = Duration.zero;

  void stopTimer() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void resetTimer() {
    timer!.cancel();
    setState(() {
      started = false;
      seconds = 0;
      minutes = 0;
      hours = 0;
      digitSecond = "00";
      digitMinutes = "00";
      digitHours = "00";
      laps = [];
      lastLapTime = Duration.zero;
    });
  }

  void addLap() {
    Duration currentTime =
        Duration(hours: hours, minutes: minutes, seconds: seconds);
    Duration lapTime = currentTime - lastLapTime;
    String formattedLapTime =
        "${lapTime.inHours.toString().padLeft(2, '0')}:${(lapTime.inMinutes % 60).toString().padLeft(2, '0')}:${(lapTime.inSeconds % 60).toString().padLeft(2, '0')}";
    String lap =
        "$digitHours:$digitMinutes:$digitSecond   (Lap: $formattedLapTime)";
    setState(() {
      laps.add(lap);
      lastLapTime = currentTime;
    });
  }

  void startTimer() {
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;
      if (localSeconds > 59) {
        localSeconds = 0;
        localMinutes++;
        if (localMinutes > 59) {
          localMinutes = 0;
          localHours++;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSecond = seconds < 10 ? "0$seconds" : "$seconds";
        digitMinutes = minutes < 10 ? "0$minutes" : "$minutes";
        digitHours = hours < 10 ? "0$hours" : "$hours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Stopwatch",
                  style: TextStyle(
                    color: isDarkMode
                        ? kDarkColorScheme.onPrimaryContainer
                        : kcolorScheme.onPrimaryContainer,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "by Huraira",
                  style: TextStyle(
                    color: isDarkMode
                        ? kDarkColorScheme.onPrimaryContainer
                        : kcolorScheme.onPrimaryContainer,
                    fontSize: 17,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  "$digitHours:$digitMinutes:$digitSecond",
                  style: TextStyle(
                    color: isDarkMode
                        ? kDarkColorScheme.onPrimaryContainer
                        : kcolorScheme.onPrimaryContainer,
                    fontSize: 75,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 355.0,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? kDarkColorScheme.primary
                      : kcolorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? kDarkColorScheme.secondaryContainer
                              : kcolorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lap ${index + 1}",
                                style: TextStyle(
                                    color: isDarkMode
                                        ? kDarkColorScheme.secondary
                                        : kcolorScheme.secondary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${laps[index]}",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? kDarkColorScheme.secondary
                                      : kcolorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? startTimer() : stopTimer();
                      },
                      hoverColor: isDarkMode
                          ? kDarkColorScheme.secondary
                          : kcolorScheme.secondary,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.tealAccent,
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Text(
                        (!started) ? "Start" : "Pause",
                        style: isDarkMode
                            ? const TextStyle(color: Colors.white)
                            : const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      addLap();
                    },
                    icon: const Icon(Icons.flag),
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        resetTimer();
                      },
                      fillColor: isDarkMode
                          ? kDarkColorScheme.secondary
                          : kcolorScheme.secondary,
                      shape: const StadiumBorder(),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          color: isDarkMode
                              ? kDarkColorScheme.onSecondary
                              : kcolorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
