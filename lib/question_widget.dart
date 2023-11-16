import 'package:flutter/material.dart';
import 'quiz_response_class.dart';

class QuestionWidget extends StatefulWidget {
  final String questionText;
  final List<String> answerOptions;
  final List<QuizResponse> answeredQuestionsList;
  final Function(String, int) onAnswerSelected;
  final VoidCallback onNextQuestion;
  final int currentQuestionIndex;

  const QuestionWidget({super.key,
    required this.questionText,
    required this.answerOptions,
    required this.answeredQuestionsList,
    required this.onAnswerSelected,
    required this.onNextQuestion,
    required this.currentQuestionIndex,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int? _selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    _loadSelectedAnswer();
  }

  void _loadSelectedAnswer() {
    setState(() {
      final response = widget.answeredQuestionsList.firstWhere(
            (element) => element.questionIndex == widget.currentQuestionIndex,
        orElse: () => QuizResponse(questionIndex: -1, selectedAnswer: ""),
      );
      if (response.questionIndex == widget.currentQuestionIndex) {
        _selectedAnswerIndex = widget.answerOptions.indexOf(response.selectedAnswer);
      } else {
        _selectedAnswerIndex = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.questionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.answerOptions.length,
                itemBuilder: (context, index) {
                  final answer = widget.answerOptions[index];
                  bool isSelected = _selectedAnswerIndex == index;

                  return RadioListTile<int>(
                    title: Text(
                      answer,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    value: index,
                    groupValue: isSelected ? _selectedAnswerIndex : null,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswerIndex = value;
                        widget.onAnswerSelected(answer, index);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Center(
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