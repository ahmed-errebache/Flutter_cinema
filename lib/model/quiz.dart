import 'dart:convert';

class Quiz {
  final int quiz_id;
  final String quiz;

  Quiz({required this.quiz_id, required this.quiz});

  factory Quiz.fromRawJson(String str) => Quiz.fromJson(json.decode(str));

  factory Quiz.fromJson(Map<String, dynamic> j) {
    return Quiz(
      quiz_id: j['quiz_id'] as int,
      quiz: j['quiz'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Quiz && other.quiz_id == quiz_id && other.quiz == quiz;

  @override
  int get hashCode => Object.hash(quiz_id, quiz);
}
