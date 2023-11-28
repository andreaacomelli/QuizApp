import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'question_class.dart';
import 'dart:math';

Future<List<Question>> loadQuestions() async {
  final String csvData = await rootBundle.loadString('assets/domande.csv');
  final List<List<dynamic>> csvTable =
      const CsvToListConverter().convert(csvData);
  final List<Question> questionList = [];

  for (var i = 1; i < csvTable.length; i++) {
    final questionData = csvTable[i];
    final questionText = questionData[0] as String;
    final correctAnswer = questionData[3] as String;
    final List<String> answerOptions =
        List<String>.from(questionData.sublist(1, 3));

    answerOptions.add(correctAnswer);

    answerOptions.shuffle(Random());

    final question = Question(
      questionText: questionText,
      correctAnswer: correctAnswer,
      answerOptions: answerOptions,
    );

    questionList.add(question);
  }

  questionList.shuffle(Random());
  return questionList;
}