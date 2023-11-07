import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esame sicurezza aziendale'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Questa applicazione ti permetterà di esercitarti all\'esame antincendio\n'
                  '\nPreparati per l\'esame rispondendo alle 15 domande che seguiranno\n'
                  '\nPer superarlo, potrai fare al massimo 5 errori',
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => QuizScreen(),
                  ),
                );
              },
              child: Text('Inizia il Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}