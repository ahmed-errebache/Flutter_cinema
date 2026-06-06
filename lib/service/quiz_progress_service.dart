import 'package:shared_preferences/shared_preferences.dart';

class QuizProgressService {
  static const _keyNom = 'player_name';
  static const _prefixScore = 'quiz_score_';
  static const _prefixJoue = 'quiz_joue_';

  Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNom, name);
  }

  Future<String?> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNom);
  }

  Future<void> saveScore(int quizId, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final meilleur = prefs.getInt('$_prefixScore$quizId') ?? 0;
    if (score > meilleur) {
      await prefs.setInt('$_prefixScore$quizId', score);
    }
    await prefs.setBool('$_prefixJoue$quizId', true);
  }

  Future<int?> getMeilleurScore(int quizId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_prefixScore$quizId');
  }

  Future<bool> aDejaJoue(int quizId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefixJoue$quizId') ?? false;
  }
}
