import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, {super.key});
  final Function() startQuiz;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 200,
            color: const Color.fromRGBO(
              255,
              255,
              255,
              0.355,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Text(
            "Learn Flutter the Fun Way!!",
            style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 255, 194, 234),
                fontSize: 22,
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Coded by Huraira",
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 255, 194, 234),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          OutlinedButton.icon(
            onPressed: () {
              startQuiz();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.arrow_right_alt_outlined,
            ),
            label: Text(
              "Get Started",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 255, 194, 234),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
