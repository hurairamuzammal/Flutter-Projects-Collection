import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color mainColor = const Color(0xFF000633);
  static Color bgcolor = const Color(0xFFe2e2ff);
  static Color accentColor = const Color(0xFF0065FF);

  // Settings the cards differnt colors
  static List<Color> cardColors = [
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.pink.shade100,
    Colors.blueGrey.shade100,
    Colors.teal.shade100,
    Colors.brown.shade100,
    Colors.indigo.shade100,
    Colors.lime.shade100,
  ];

  static TextStyle mainTitle = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: mainColor,
  );
  static TextStyle maincontent = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: mainColor,
  );
  static TextStyle dateTitle = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: mainColor,
  );
}
