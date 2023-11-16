import 'package:flutter/material.dart';

import 'start_screen.dart';

void main() => runApp(const QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Esame sicurezza aziendale',
      home: StartScreen(),
    );
  }
}