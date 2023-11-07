import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String questionText;
  final String correctAnswer;
  final List<String> answerOptions;
  final Function(String) onAnswerSelected;
  final int currentQuestionIndex;
  final Function() onNextQuestion;
  final int selectedOptionIndex = -1;

  QuestionWidget({
    required this.questionText,
    required this.correctAnswer,
    required this.answerOptions,
    required this.onAnswerSelected,
    required this.currentQuestionIndex,
    required this.onNextQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Text(
            questionText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: List.generate(answerOptions.length, (index) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RadioListTile(
                    title: Text(
                      answerOptions[index],
                      softWrap: true,),
                    value: index,
                    groupValue: selectedOptionIndex,
                    onChanged: (int? value) {
                      onAnswerSelected(answerOptions[value!]);
                    },
                  )
              );
            }),
          ),
        ],
      ),
    );
  }
}
