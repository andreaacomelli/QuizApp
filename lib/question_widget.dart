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
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int? _selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    _loadSelectedAnswer();
  }

  void _loadSelectedAnswer() {
    final response = widget.answeredQuestionsList.firstWhere(
          (element) => element.questionIndex == widget.currentQuestionIndex,
      orElse: () => QuizResponse(questionIndex: -1, selectedAnswer: ""),
    );
    if (response.questionIndex == widget.currentQuestionIndex) {
      setState(() {
        _selectedAnswerIndex = widget.answerOptions.indexOf(response.selectedAnswer);
      });
    } else {
      setState(() {
        _selectedAnswerIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurpleAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.questionText,
                style: const TextStyle(fontFamily: 'Poppins',fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.answerOptions.length,
                itemBuilder: (context, index) {
                  final answer = widget.answerOptions[index];
                  bool isSelected = _selectedAnswerIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RadioListTile<int>(
                      fillColor:
                      MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return(isSelected ? Colors.deepPurpleAccent : Colors.black);
                        }),
                      title: Text(
                        answer,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      value: index,
                      groupValue: _selectedAnswerIndex,
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswerIndex = value;
                          widget.onAnswerSelected(answer, index);
                        });
                      },
                    )
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Fai swipe verso destra e sinistra\n'
                  'per navigare tra le domande',
              style: TextStyle(
                fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurpleAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}