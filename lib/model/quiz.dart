class Quiz {
  final int quiz_id;
  final String quiz;

  Quiz({required this.quiz_id, required this.quiz});

  factory Quiz.fromJson(Map<String, dynamic> j) {
    return Quiz(
      quiz_id: j['quiz_id'] as int,
      quiz: j['quiz'] as String,
    );
  }
}