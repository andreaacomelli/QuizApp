import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Question> _questions = [
    Question(
      questionText: 'Qual è la capitale dell\'Italia?',
      options: ['Roma', 'Milano', 'Firenze', 'Napoli'],
      correctOption: 'Roma',
    ),
    Question(
      questionText: 'Qual è il più grande pianeta del sistema solare?',
      options: ['Terra', 'Marte', 'Giove', 'Venere'],
      correctOption: 'Giove',
    ),
    // Aggiungi più domande
  ];

  void _checkAnswer(String selectedOption) {
    if (_questions[_currentQuestionIndex].correctOption == selectedOption) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => QuizResultScreen(
              score: _score,
              onRetryQuiz: () {
                // Callback per riavviare il quiz
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                  _questions.shuffle(); // Mescola le domande
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _questions[_currentQuestionIndex].questionText,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Column(
              children: _questions[_currentQuestionIndex]
                  .options
                  .map((option) => ElevatedButton(
                onPressed: () => _checkAnswer(option),
                child: Text(option),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctOption;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOption,
  });
}

class QuizResultScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRetryQuiz;

  QuizResultScreen({required this.score, required this.onRetryQuiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Risultato del Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hai completato il quiz!',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Punteggio: $score',
              style: TextStyle(fontSize: 18.0),
            ),
            ElevatedButton(
              onPressed: onRetryQuiz,
              child: Text('Ritenta il Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}