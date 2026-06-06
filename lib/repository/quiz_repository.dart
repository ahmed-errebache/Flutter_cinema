import '../model/quiz.dart';
import '../service/quiz_service.dart';
import '../model/question.dart';

class QuizRepository {
  Future<List<Quiz>> getQuizzes() async {
    final quizzes = await fetchQuizzes();

    // quizzes.sort((a, b) => a.quiz.compareTo(b.quiz));
    return quizzes;
  }

  Future<List<Question>> getQuestions(int quizId) async {
  return await fetchQuestions(quizId);
}

}

