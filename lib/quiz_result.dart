import 'package:flutter/material.dart';
import 'question_class.dart';
import 'quiz_screen.dart';

class QuizResult extends StatelessWidget {
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalQuestions;
  final List<Question> shuffledQuestions;
  final List<String> answerOptions;
  final int selectedOptionIndex;

  QuizResult({
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.totalQuestions,
    required this.shuffledQuestions,
    required this.answerOptions,
    required this.selectedOptionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Risultato del Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Risultati del Quiz',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text('Domande corrette: $correctAnswers'),
            Text('Domande sbagliate: $incorrectAnswers'),

            ElevatedButton(
              onPressed: () {
                // Naviga alla schermata dei risultati
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => QuizScreen()
                  ),
                ); // Torna alla schermata del quiz
              },
              child: Text('Ritenta il Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}