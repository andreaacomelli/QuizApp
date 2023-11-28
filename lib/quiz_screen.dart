import 'dart:math';
import 'package:flutter/material.dart';

import 'quiz_response_class.dart';
import 'question_widget.dart';
import 'questions_load.dart';
import 'question_class.dart';
import 'quiz_result.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final List<QuizResponse> _answeredQuestionsList = [];
  final Map<int, QuizResponse> _quizResponses = {};
  final Map<int, String> _questionAnswers = {};
  List<Question> _shuffledQuestions = [];
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  final int _maxQuestions = 15;
  final int _answeredQuestions = 0;
  int _selectedOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadQuestions().then((questionList) {
      _shuffledQuestions = _shuffleQuestions(questionList);
      setState(() {
        _questions = questionList;
        _totalQuestions = _questions.length;
      });
    });
  }

  Future<List<Question>> _loadQuestions() async {
    return await loadQuestions();
  }

  void _onAnswerSelected(String selectedAnswer, int selectedIndex) {
    if (_currentQuestionIndex < _shuffledQuestions.length) {
      final currentQuestionIndex = _pageController.page?.toInt() ?? 0;

      _checkAnswer(selectedAnswer,
          _shuffledQuestions[currentQuestionIndex].correctAnswer);

      if (_questionAnswers.containsKey(currentQuestionIndex)) {
        if (_questionAnswers[currentQuestionIndex] != selectedAnswer) {
          _questionAnswers[currentQuestionIndex] = selectedAnswer;
          _answeredQuestionsList.removeWhere(
              (response) => response.questionIndex == currentQuestionIndex);
          _answeredQuestionsList.add(QuizResponse(
              questionIndex: currentQuestionIndex,
              selectedAnswer: selectedAnswer));
        }
      } else {
        _questionAnswers[currentQuestionIndex] = selectedAnswer;
        _answeredQuestionsList.add(QuizResponse(
            questionIndex: currentQuestionIndex,
            selectedAnswer: selectedAnswer));
      }

      setState(() {
        _selectedOptionIndex = selectedIndex;
      });
      _onNextQuestion();
    }
  }

  void _checkAnswer(String userAnswer, String correctAnswer) {
    if (userAnswer == correctAnswer) {
      _correctAnswers++;
    } else {
      _incorrectAnswers++;
    }
  }

  void _updateQuizResponses(int questionIndex, String selectedAnswer) {
    _quizResponses[questionIndex] = QuizResponse(
        questionIndex: questionIndex, selectedAnswer: selectedAnswer);
  }

  void _onNextQuestion() {
    int? index = (_pageController.page)?.toInt();
    print("Index: ${index}");
    print("answered questions: ${_answeredQuestions}");

    print("answeredQuestionsList: ${_answeredQuestionsList.length}");
    print("max questions: ${_maxQuestions}");

    setState(() {
      if (index! < (_maxQuestions - 1)) {
        _currentQuestionIndex++;

        if (_quizResponses.containsKey(_currentQuestionIndex)) {
          _selectedOptionIndex = _shuffledQuestions[_currentQuestionIndex]
              .answerOptions
              .indexOf(_quizResponses[_currentQuestionIndex]!.selectedAnswer);
        } else {
          _selectedOptionIndex = -1;
        }

        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        if (index <= 14) {
        } else if (_answeredQuestionsList.length == _maxQuestions) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => QuizResult(
                correctAnswers: _correctAnswers,
                incorrectAnswers: _incorrectAnswers,
                totalQuestions: _totalQuestions,
                shuffledQuestions: _shuffledQuestions,
                selectedOptionIndex: _selectedOptionIndex,
                answerOptions: _questions[_currentQuestionIndex].answerOptions,
                questions: _questions,
                currentQuestion: _questions[_currentQuestionIndex],
                quizResponses: _quizResponses,
              ),
            ),
          );
        }
      }
    });
  }

  List<Question> _shuffleQuestions(List<Question> questions) {
    var random = Random();
    List<Question> shuffledQuestions = List<Question>.from(questions);
    shuffledQuestions.shuffle(random);
    return shuffledQuestions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Esame sicurezza Aziendale',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _totalQuestions,
        itemBuilder: (context, index) {
          if (index >= _maxQuestions) {
            return const SizedBox.shrink();
          }
          final questionData = _questions[index];
          final questionText = questionData.questionText;
          final answerOptions = questionData.answerOptions;

          return QuestionWidget(
            currentQuestionIndex: _currentQuestionIndex,
            questionText: questionText,
            answerOptions: answerOptions,
            answeredQuestionsList: _answeredQuestionsList,
            onAnswerSelected: _onAnswerSelected,
            onNextQuestion: _onNextQuestion,
          );
        },
      ),
      floatingActionButton: _answeredQuestions >= _maxQuestions
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Rispondi a tutte le $_maxQuestions domande',
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
                            correctAnswers: _correctAnswers,
                            incorrectAnswers: _incorrectAnswers,
                            totalQuestions: _totalQuestions,
                            shuffledQuestions: _shuffledQuestions,
                            selectedOptionIndex: _selectedOptionIndex,
                            answerOptions:
                                _questions[_currentQuestionIndex].answerOptions,
                            questions: _questions,
                            currentQuestion: _questions[_currentQuestionIndex],
                            quizResponses: _quizResponses,
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
                          borderRadius: BorderRadius.circular(32.0)),
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
