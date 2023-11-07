import 'package:flutter/material.dart';
import 'start_screen.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Esame sicurezza aziendale',
      home: StartScreen(),
    );
  }
}