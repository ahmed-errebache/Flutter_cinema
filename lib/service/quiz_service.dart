import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/question.dart';
import '../model/quiz.dart';

Future<List<Quiz>> fetchQuizzes() async {
  final response = await http.get(
    Uri.parse('https://api.neotech.fr/quizzes?select=quiz_id,quiz')
  );

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map( (e) => Quiz.fromJson(e) ).toList();
  } else {
    throw Exception("Erreur API");
  }
}

Future<List<Question>> fetchQuestions(int quizId) async {
  final response = await http.get(
    Uri.parse('https://api.neotech.fr/quizzes?quiz_id=eq.$quizId'),
  );
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => Question.fromJson(e)).toList();
  } else {
    throw Exception('Erreur API questions');
  }
}

