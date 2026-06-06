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
      quiz_id: j['quiz_id'] as int,
      question: j['question'] as String,
      autres: [
        j['reponse_a'] as String,
        j['reponse_b'] as String,
        j['reponse_c'] as String,
      ],
      reponse: j['bonne_reponse'] as String,
    );
  }
}
