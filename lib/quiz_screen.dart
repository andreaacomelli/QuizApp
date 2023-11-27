import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

import 'quiz_response_class.dart';
import 'question_widget.dart';
import 'question_class.dart';
import 'quiz_result.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
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
  List<QuizResponse> answeredQuestionsList = [];
  Map<int, QuizResponse> quizResponses = {};
  List<Question> shuffledQuestions = [];

  Map<int, String> questionAnswers = {};

  void onAnswerSelected(String selectedAnswer, int selectedIndex) {
    if (currentQuestionIndex < shuffledQuestions.length) {
      final currentQuestionIndex = pageController.page?.toInt() ?? 0;

      checkAnswer(selectedAnswer, shuffledQuestions[currentQuestionIndex].correctAnswer);

      if (questionAnswers.containsKey(currentQuestionIndex)) {
        if (questionAnswers[currentQuestionIndex] != selectedAnswer) {
          questionAnswers[currentQuestionIndex] = selectedAnswer;
          answeredQuestionsList.removeWhere((response) => response.questionIndex == currentQuestionIndex);
          answeredQuestionsList.add(QuizResponse(questionIndex: currentQuestionIndex, selectedAnswer: selectedAnswer));
        }
      } else {
        questionAnswers[currentQuestionIndex] = selectedAnswer;
        answeredQuestionsList.add(QuizResponse(questionIndex: currentQuestionIndex, selectedAnswer: selectedAnswer));
      }

      setState(() {
        _selectedOptionIndex = selectedIndex;
      });
      onNextQuestion();
    }
  }







  void checkAnswer(String userAnswer, String correctAnswer) {
    if (userAnswer == correctAnswer) {
      correctAnswers++;
    } else {
      incorrectAnswers++;
    }
  }

  void collectAnswers() {

  }

  void updateQuizResponses(int questionIndex, String selectedAnswer) {
    quizResponses[questionIndex] = QuizResponse(questionIndex: questionIndex, selectedAnswer: selectedAnswer);
  }

  void onNextQuestion() {
    int? index = (pageController.page)?.toInt();
    print("Index: ${index}");
    print("answered questions: ${answeredQuestions}");

    print("answeredQuestionsList: ${answeredQuestionsList.length}");
    print("max questions: ${maxQuestions}");

    setState(() {
      if (index! < (maxQuestions - 1)) {
        currentQuestionIndex++;

        if (quizResponses.containsKey(currentQuestionIndex)) {
          _selectedOptionIndex = shuffledQuestions[currentQuestionIndex]
              .answerOptions
              .indexOf(quizResponses[currentQuestionIndex]!.selectedAnswer);
        } else {
          _selectedOptionIndex = -1;
        }

        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        if (index <= 14) {


        } else if(answeredQuestionsList.length == maxQuestions){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  QuizResult(
                    correctAnswers: correctAnswers,
                    incorrectAnswers: incorrectAnswers,
                    totalQuestions: totalQuestions,
                    shuffledQuestions: shuffledQuestions,
                    selectedOptionIndex: _selectedOptionIndex,
                    answerOptions: questions[currentQuestionIndex].answerOptions,
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
    loadQuestions().then((_) {
      shuffledQuestions = shuffleQuestions(questions);
    });
  }

  List<Question> shuffleQuestions(List<Question> questions) {
    var random = Random();
    List<Question> shuffledQuestions = List<Question>.from(questions);
    shuffledQuestions.shuffle(random);
    return shuffledQuestions;
  }

  Future<void> loadQuestions() async {
    final String csvData = await rootBundle.loadString('assets/domande.csv');
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
    final List<Question> questionList = [];

    for (var i = 1; i < csvTable.length; i++) {
      final questionData = csvTable[i];
      final questionText = questionData[0] as String;
      final correctAnswer = questionData[1] as String;
      final List<String> answerOptions = List<String>.from(questionData.sublist(2));

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
        title: const Text('Esame sicurezza Aziendale',
          textAlign: TextAlign.center,

          style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: totalQuestions,
        itemBuilder: (context, index) {
          if (index >= maxQuestions) {
            return const SizedBox.shrink();
          }
          final questionData = questions[index];
          final questionText = questionData.questionText;
          final answerOptions = questionData.answerOptions;

          return QuestionWidget(
            currentQuestionIndex: currentQuestionIndex,
            questionText: questionText,
            answerOptions: answerOptions,
            answeredQuestionsList: answeredQuestionsList,
            onAnswerSelected: onAnswerSelected,
            onNextQuestion: onNextQuestion,
          );
        },
      ),
      floatingActionButton: answeredQuestions >= maxQuestions
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Rispondi a tutte le $maxQuestions domande',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
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
                          answerOptions: questions[currentQuestionIndex].answerOptions,
                          questions: questions,
                          currentQuestion: questions[currentQuestionIndex],
                          quizResponses: quizResponses,
                        ),
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
                  ),
                  child: const Text('Visualizza i risultati'),
                ),
              ],
            ),
          )
          : null,
    );
  }
}