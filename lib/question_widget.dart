import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final String questionText;
  final List<String> answerOptions;
  final Function(String, int) onAnswerSelected;
  final Function onNextQuestion;

  QuestionWidget({
    required this.questionText,
    required this.answerOptions,
    required this.onAnswerSelected,
    required this.onNextQuestion,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? _site;

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
            children: <Widget>[
              Text(
                widget.questionText,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Column(
                children: <Widget>[
                  for (int index = 0; index < widget.answerOptions.length; index++)
                    ListTile(
                      title: Text(
                        widget.answerOptions[index],
                        softWrap: true,
                      ),
                      leading: Radio<String>(
                        value: widget.answerOptions[index],
                        groupValue: _site,
                        onChanged: (String? value) {
                          widget.onAnswerSelected(value!, index);
                          setState(() {
                            _site = value;
                            _selectedIndex = index;
                          });
                        },
                      ),
                    ),
                ],
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
