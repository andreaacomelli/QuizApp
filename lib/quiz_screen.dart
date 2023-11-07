import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'question_widget.dart';
import 'package:csv/csv.dart';
import 'question_class.dart';
import 'quiz_result.dart';
import 'dart:async';
import 'dart:math';

class QuizScreen extends StatefulWidget {

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  PageController pageController = PageController(initialPage: 0);
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int totalQuestions = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int maxQuestions = 15;
  int answeredQuestions = 0;
  int selectedOptionIndex = -1;

  List<Question> shuffledQuestions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
    shuffledQuestions = shuffleQuestions(questions);
  }

  List<Question> shuffleQuestions(List<Question> questions) {
    var random = Random();
    List<Question> shuffledQuestions = List<Question>.from(questions);
    shuffledQuestions.shuffle(random);
    return shuffledQuestions;
  }

  Future<void> loadQuestions() async {
    final String csvData = await rootBundle.loadString('assets/domande.csv');
    final List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
    final List<Question> questionList = [];

    for (var i = 1; i < csvTable.length; i++) { // Inizia da 1 per escludere l'intestazione
      final questionData = csvTable[i];
      final questionText = questionData[0] as String;
      final correctAnswer = questionData[1] as String;
      final answerOptions = List<String>.from(questionData.sublist(2));

      answerOptions.shuffle(Random());

      final question = Question(
        questionText: questionText,
        correctAnswer: correctAnswer,
        answerOptions: answerOptions,
      );
      questionList.add(question);
    }

    questionList.shuffle(Random()); // Mescola ordine domande

    setState(() {
      questions = questionList;
      totalQuestions = questions.length;
    });
  }

  void checkAnswer(String userAnswer, String correctAnswer) {
    if (userAnswer == correctAnswer) {
      correctAnswers++;
    } else {
      incorrectAnswers++;
    }
    onNextQuestion();
  }

  void onNextQuestion() {
    setState(() {
      if (answeredQuestions < 15) {
        // print(selectedOptionIndex);
        if (currentQuestionIndex < totalQuestions - 1) {
          currentQuestionIndex++;
          pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);// Passa alla prossima domanda
        } else {
          if(answeredQuestions == 15){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => QuizResult(
                    correctAnswers: correctAnswers,
                    incorrectAnswers: incorrectAnswers,
                    totalQuestions: totalQuestions,
                    shuffledQuestions: [],
                    answerOptions: [],
                    selectedOptionIndex: selectedOptionIndex),
              ),
            );
          }
        }
        answeredQuestions++; // Incrementa il numero di domande a cui hai risposto
      }
    });
  }

  void onAnswerSelected(String selectedAnswer) {
    final questionData = shuffledQuestions[currentQuestionIndex];
    checkAnswer(selectedAnswer, questionData.correctAnswer);
    answeredQuestions++;

    onNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esame sicurezza Aziendale'),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: totalQuestions,
        itemBuilder: (context, index) {
          if (index >= 15) {
            return SizedBox.shrink();
          }
          final questionData = questions[index];
          final questionText = questionData.questionText;
          final correctAnswer = questionData.correctAnswer;
          final answerOptions = questionData.answerOptions;
          return QuestionWidget(
            questionText: questionText,
            correctAnswer: correctAnswer,
            answerOptions: answerOptions,
            currentQuestionIndex: currentQuestionIndex,
            onAnswerSelected: (selectedAnswer) {
              checkAnswer(selectedAnswer, correctAnswer);
            },
            onNextQuestion: () {
              // Aggiorna l'indice selezionato alla domanda successiva
              setState(() {
                onNextQuestion();
              });
            },
          );
        },
      ),

      floatingActionButton: answeredQuestions >= maxQuestions
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Hai risposto a tutte le 15 domande',
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
                        builder: (BuildContext context) => QuizResult(
                            correctAnswers: correctAnswers,
                            incorrectAnswers: incorrectAnswers,
                            totalQuestions: totalQuestions,
                            shuffledQuestions: [],
                            answerOptions: [],
                            selectedOptionIndex: selectedOptionIndex),
                      ),
                    );
                  },
                  child: Text('Visualzizza il risultato'),
                ),
              ],
            ),
      )
          : null, // Il pulsante appare solo quando hai risposto a tutte le domande
    );
  }
}