import 'package:acteurs/model/quiz.dart';
import 'package:acteurs/repository/quiz_repository.dart';
import 'package:acteurs/view/quiz_jeu_view.dart';
import 'package:custom_cached_image/custom_cached_image.dart';
import 'package:flutter/material.dart';

class QuizSelectionView extends StatefulWidget {
  final String nomJoueur;
  const QuizSelectionView({super.key, required this.nomJoueur});

  @override
  State<QuizSelectionView> createState() => _QuizSelectionViewState();
}

class _QuizSelectionViewState extends State<QuizSelectionView> {
  final _repository = QuizRepository();
  late Future<List<Quiz>> _futureQuizzes;

  @override
  void initState() {  
    super.initState();
    _futureQuizzes = _repository.getQuizzes();
  }

  void _lancerQuiz(Quiz quiz) async {
    final questions = await _repository.getQuestions(quiz.quiz_id);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizJeuView(
          quiz: quiz,
          questions: questions,
          nomJoueur: widget.nomJoueur,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B2CBF), Color(0xff240046)],
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Text(
                  'Bonjour ${widget.nomJoueur} !',
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Choisis un thème',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Quiz>>(
              future: _futureQuizzes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }
                final quizzes = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) => _quizCard(quizzes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _quizCard(Quiz quiz) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _lancerQuiz(quiz),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomCachedImage(
                  imageUrl: 'https://img.neotech.fr/cgi/images/tr:width=100/cinema%2fquiz%2f${quiz.quiz_id}.png',
                  width: 80,
                  height: 80,
                  borderRadius: 8,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.quiz, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  quiz.quiz,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
