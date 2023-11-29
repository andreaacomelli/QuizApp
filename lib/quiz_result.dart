import 'package:flutter/material.dart';

import 'quiz_response_class.dart';
import 'question_class.dart';
import 'quiz_screen.dart';

class QuizResult extends StatelessWidget {
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalQuestions;
  final List<Question> shuffledQuestions;
  final List<String> answerOptions;
  final int selectedOptionIndex;
  final List<Question> questions;
  final Map<int, QuizResponse> quizResponses;

  const QuizResult({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.totalQuestions,
    required this.shuffledQuestions,
    required this.answerOptions,
    required this.selectedOptionIndex,
    required Question currentQuestion,
    required this.questions,
    required this.quizResponses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Risultato del quiz',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Risultati del Quiz'),
            const SizedBox(height: 20.0),
            Text('Domande corrette: $correctAnswers'),
            Text('Domande sbagliate: $incorrectAnswers'),
            ElevatedButton(
              onPressed: () {
                // Naviga alla schermata dei risultati
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const QuizScreen()),
                ); // Torna alla schermata del quiz
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                shadowColor: Colors.deepPurple,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: const Size(150, 60),
              ),
              child: const Text(
                  'Ritenta il Quiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
