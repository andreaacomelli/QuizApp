
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