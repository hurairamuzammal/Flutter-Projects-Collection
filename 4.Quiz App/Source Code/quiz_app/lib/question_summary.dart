import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: DefaultTextStyle(
          style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 213, 243),
          ),
          child: Column(
            children: summaryData.map(
              (data) {
                bool isCorrect = (data['user_answer'] as String) ==
                    (data['correct_answer'] as String);
                return Row(
                  textBaseline: TextBaseline.ideographic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(((data['question_index'] as int) + 1).toString()),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(data['question'] as String),
                          Text(
                            "Your Response :  ${data['user_answer'] as String}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCorrect ? Colors.green : Colors.red),
                          ),
                          Text(
                            "Correct Answer :  ${data['correct_answer'] as String}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
