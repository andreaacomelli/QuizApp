import 'package:flutter/material.dart';

import 'quiz_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Esame sicurezza aziendale',
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
          children: <Widget>[
            const Text(
              'Questa applicazione ti permetterà di esercitarti all\'esame antincendio\n\n'
                  '\nPreparati per l\'esame rispondendo alle 15 domande che seguiranno\n\n'
                  '\nPer superarlo, potrai fare al massimo 5 errori',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 150.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const QuizScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                shadowColor: Colors.deepPurple,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)
                ),
                minimumSize: const Size(150, 60),
              ),
              child: const Text(
                'Inizia il Quiz',
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