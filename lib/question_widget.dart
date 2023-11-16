import 'package:flutter/material.dart';

import 'quiz_response_class.dart';

class QuestionWidget extends StatefulWidget {
  final String questionText;
  final List<String> answerOptions;
  final List<QuizResponse> answeredQuestionsList;
  final Function(String, int) onAnswerSelected;
  final VoidCallback onNextQuestion;

  QuestionWidget({
    required this.questionText,
    required this.answerOptions,
    required this.answeredQuestionsList,
    required this.onAnswerSelected,
    required this.onNextQuestion,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  Map<int, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedAnswers();
  }

  void _loadSelectedAnswers() {
    for (var response in widget.answeredQuestionsList) {
      _selectedAnswers[response.questionIndex] = widget.answerOptions.indexOf(response.selectedAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.questionText,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.answerOptions.length,
                itemBuilder: (context, index) {
                  final answer = widget.answerOptions[index];
                  bool isSelected = _selectedAnswers.containsKey(index);

                  return RadioListTile<int>(
                    title: Text(
                      answer,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    value: index,
                    groupValue: isSelected ? _selectedAnswers[index] : null,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswers[index] = value!;
                        widget.onAnswerSelected(answer, index);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Fai swipe verso destra e sinistra per navigare tra le domande',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
