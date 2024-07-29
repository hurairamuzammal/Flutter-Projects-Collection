import 'package:flutter/material.dart';
//adding button dart file here
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class QuestionScreen extends StatefulWidget {
  QuestionScreen({super.key, required this.onSelectedAnswer});
  final void Function(String) onSelectedAnswer;
  var indexNumber = 0;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  void answerQuestion(String chooseAnswer) {
    widget.onSelectedAnswer(chooseAnswer);
  }

  void indexIncrement() {
    setState(() {
      widget.indexNumber++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[widget.indexNumber];

    return SizedBox(
      // this command use all the width on screen
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromARGB(255, 255, 194, 234)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...currentQuestion.getShuffledAnswers().map(
              (answer) {
                return AnswerButton(
                  answerText: answer,
                  onTap: () {
                    indexIncrement();
                    answerQuestion(answer);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
