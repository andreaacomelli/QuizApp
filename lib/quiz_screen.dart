import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

import 'question_class.dart';
import 'question_widget.dart';
import 'quiz_result.dart';

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
  int _selectedOptionIndex = -1;

  Map<int, QuizResponse> quizResponses = {};

  List<Question> shuffledQuestions = [];

  void onAnswerSelected(String selectedAnswer, int selectedIndex) {
    final questionData = shuffledQuestions[currentQuestionIndex];
    checkAnswer(selectedAnswer, questionData.correctAnswer);
    updateQuizResponses(currentQuestionIndex, selectedAnswer);

    answeredQuestions++;
    setState(() {
      _selectedOptionIndex = selectedIndex;
    });

    onNextQuestion();
  }

  void checkAnswer(String userAnswer, String correctAnswer) {
    if (userAnswer == correctAnswer) {
      correctAnswers++;
    } else {
      incorrectAnswers++;
    }
  }

  void updateQuizResponses(int questionIndex, String selectedAnswer) {
    quizResponses[questionIndex] = QuizResponse(
      questionIndex: questionIndex,
      selectedAnswer: selectedAnswer,
    );
  }

  void onNextQuestion() {
    int? index = (pageController.page)?.toInt();
    setState(() {
      if (index! < (maxQuestions - 1)) {
        currentQuestionIndex++;

        print("Page Controller: ${(pageController.page)?.toInt()}");
        print("Current Question Index: ${currentQuestionIndex}");
        print("Total Question: ${totalQuestions}");
        print("Correct Answers: ${correctAnswers}");
        print("Incorrect Answer: ${incorrectAnswers}");
        print("Max Questions: ${maxQuestions}");
        print("Answered Questions: ${answeredQuestions}");
        print("Selected Option Index: ${selectedOptionIndex}");
        print("_Selected Option Index: ${_selectedOptionIndex}");

        print("Index: ${index}");
        print("Max questions: ${maxQuestions - 1}");

        print("Index: ${(index).runtimeType}");
        print("Max questions: ${(maxQuestions - 1).runtimeType}");

        print("Answered Questions: ${answeredQuestions}");



        // Verifica se l'utente ha già risposto a questa domanda
        if (quizResponses.containsKey(currentQuestionIndex)) {
          _selectedOptionIndex = shuffledQuestions[currentQuestionIndex]
              .answerOptions
              .indexOf(quizResponses[currentQuestionIndex]!.selectedAnswer);
        } else {
          _selectedOptionIndex = -1;
        }

        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        if (answeredQuestions != index) {
          print("Rispondi a tutte le domande");
          // L'utente deve rispondere a tutte le domande prima di visualizzare il risultato
          // Puoi aggiungere qui un messaggio o un comportamento desiderato
        } else {
          print("Arrivato!!!");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  QuizResult(
                    correctAnswers: correctAnswers,
                    incorrectAnswers: incorrectAnswers,
                    totalQuestions: totalQuestions,
                    shuffledQuestions: shuffledQuestions,
                    selectedOptionIndex: _selectedOptionIndex,
                    answerOptions:
                    questions[currentQuestionIndex].answerOptions,
                    questions: questions,
                    currentQuestion: questions[currentQuestionIndex],
                    quizResponses: quizResponses,
                  ),
            ),
          );
        }
      }
    });
  }



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
    final String csvData =
    await rootBundle.loadString('assets/domande.csv');
    final List<List<dynamic>> csvTable =
    CsvToListConverter().convert(csvData);
    final List<Question> questionList = [];

    for (var i = 1; i < csvTable.length; i++) {
      final questionData = csvTable[i];
      final questionText = questionData[0] as String;
      final correctAnswer = questionData[1] as String;
      final answerOptions =
      List<String>.from(questionData.sublist(2));

      answerOptions.shuffle(Random());

      final question = Question(
        questionText: questionText,
        correctAnswer: correctAnswer,
        answerOptions: answerOptions,
      );
      questionList.add(question);
    }

    questionList.shuffle(Random());
    setState(() {
      questions = questionList;
      totalQuestions = questions.length;
    });
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
          if (index >= maxQuestions) {
            return SizedBox.shrink();
          }
          final questionData = questions[index];
          final questionText = questionData.questionText;
          final correctAnswer = questionData.correctAnswer;
          final answerOptions = questionData.answerOptions;
          return QuestionWidget(
            questionText: questionText,
            answerOptions: answerOptions,
            onAnswerSelected: (selectedAnswer, selectedIndex) {
              checkAnswer(selectedAnswer, correctAnswer);
              setState(() {
                _selectedOptionIndex = selectedIndex;
              });
              onNextQuestion();
            },
            onNextQuestion: () {
              onNextQuestion();
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
              'Hai risposto a tutte le $maxQuestions domande',
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => QuizResult(
                      correctAnswers: correctAnswers,
                      incorrectAnswers: incorrectAnswers,
                      totalQuestions: totalQuestions,
                      shuffledQuestions: shuffledQuestions,
                      selectedOptionIndex: _selectedOptionIndex,
                      answerOptions:
                      questions[currentQuestionIndex].answerOptions,
                      questions: questions,
                      currentQuestion: questions[currentQuestionIndex],
                      quizResponses: quizResponses,
                    ),
                  ),
                );
              },
              child: Text('Visualizza il risultato'),
            ),
          ],
        ),
      )
          : null,
    );
  }
}

class QuizResponse {
  final int questionIndex;
  final String selectedAnswer;

  QuizResponse({
    required this.questionIndex,
    required this.selectedAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionIndex': questionIndex,
      'selectedAnswer': selectedAnswer,
    };
  }

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      questionIndex: json['questionIndex'],
      selectedAnswer: json['selectedAnswer'],
    );
  }
}
