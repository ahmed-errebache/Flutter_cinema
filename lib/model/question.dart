class Question {
  final int quiz_id;
  final String question;
  final List<String> autres;
  final String reponse;

  Question({
    required this.quiz_id,
    required this.question,
    required this.autres,
    required this.reponse,
  });

  factory Question.fromJson(Map<String, dynamic> j) {
    return Question(
      quiz_id: 0,
      question: j['question'] as String,
      autres: List<String>.from(j['autres']),
      reponse: j['reponse'] as String,
    );
  }
}
