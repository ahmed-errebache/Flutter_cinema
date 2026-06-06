import 'package:acteurs/repository/quiz_repository.dart';
import 'package:acteurs/service/quiz_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:acteurs/model/quiz.dart';
import 'package:acteurs/model/question.dart';

void main() {

  group('Classe Quiz', () {
    test('Conversion JSON', () {
      String chaine = '{"quiz_id": 1, "quiz": "Quel est l\'auteur du livre ?"}';

      Quiz result = Quiz.fromRawJson(chaine);

      Quiz attendu = Quiz(
        quiz_id: 1,
        quiz: "Quel est l'auteur du livre ?",
      );

      expect(result.quiz_id, 1);
      expect(result.quiz, "Quel est l'auteur du livre ?");
      expect(result, attendu);
    });

    test('Appel API', () async {
      final result = await fetchQuizzes();

      expect(result, isNotEmpty);
      expect(result[0].quiz_id, isNotNull);
      expect(result[0].quiz, isNotEmpty);
    });

    test('Repository', () async {
      final repository = QuizRepository();
      final result = await repository.getQuizzes();

      expect(result, isNotEmpty);
      expect(result[0].quiz_id, isNotNull);
    });
  });

  group('Classe Question', () {
    test('Conversion JSON', () {
      String chaine = """
{
  "question": "Total Recall",
  "reponse": "Philip K Dick",
  "autres": ["Arthur C. Clarke", "Isaac Asimov", "K. W. Jeter"]
}
      """;

      Question result = Question.fromRawJson(chaine);

      Question attendu = Question(
        quiz_id: 0,
        question: "Total Recall",
        reponse: "Philip K Dick",
        autres: ["Arthur C. Clarke", "Isaac Asimov", "K. W. Jeter"],
      );

      expect(result.question, "Total Recall");
      expect(result.reponse, "Philip K Dick");
      expect(result.autres.length, 3);
      expect(result, attendu);
    });

    test('Appel API', () async {
      final result = await fetchQuestions(1);

      expect(result, isNotEmpty);
      expect(result[0].question, isNotEmpty);
      expect(result[0].reponse, isNotEmpty);
      expect(result[0].autres.length, 3);
    });

    test('Repository', () async {
      final repository = QuizRepository();
      final result = await repository.getQuestions(1);

      expect(result, isNotEmpty);
      expect(result[0].autres.length, 3);
      expect(result[0].reponse, isNotEmpty);
    });
  });

}
