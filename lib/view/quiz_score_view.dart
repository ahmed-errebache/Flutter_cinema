import 'package:acteurs/model/quiz.dart';
import 'package:acteurs/service/quiz_progress_service.dart';
import 'package:acteurs/view/quiz_selection_view.dart';
import 'package:flutter/material.dart';

class QuizScoreView extends StatefulWidget {
  final int score;
  final int scoreMax;
  final int nbBonnes;
  final int total;
  final String nomJoueur;
  final Quiz quiz;

  const QuizScoreView({
    super.key,
    required this.score,
    required this.scoreMax,
    required this.nbBonnes,
    required this.total,
    required this.nomJoueur,
    required this.quiz,
  });

  @override
  State<QuizScoreView> createState() => _QuizScoreViewState();
}

class _QuizScoreViewState extends State<QuizScoreView> {
  final _progressService = QuizProgressService();

  @override
  void initState() {
    super.initState();
    _progressService.saveScore(widget.quiz.quiz_id, widget.score);
  }

  IconData get _mentionIcon {
    final ratio = widget.score / widget.scoreMax;
    if (ratio >= 0.8) return Icons.emoji_events;
    if (ratio >= 0.5) return Icons.thumb_up;
    return Icons.autorenew;
  }

  String get _mentionTexte {
    final ratio = widget.score / widget.scoreMax;
    if (ratio >= 0.8) return 'Excellent !';
    if (ratio >= 0.5) return 'Bien joué !';
    return 'Encore un effort !';
  }

  Color get _mentionColor {
    final ratio = widget.score / widget.scoreMax;
    if (ratio >= 0.8) return Colors.amber;
    if (ratio >= 0.5) return Colors.green;
    return Colors.orange;
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
                Text(
                  'Résultat',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  widget.quiz.quiz,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.nomJoueur,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '${widget.score}',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B2CBF),
                    ),
                  ),
                  Text(
                    'points sur ${widget.scoreMax}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.nbBonnes} / ${widget.total} bonnes réponses',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  Icon(_mentionIcon, size: 48, color: _mentionColor),
                  SizedBox(height: 8),
                  Text(
                    _mentionTexte,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _mentionColor),
                  ),
                  SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizSelectionView(nomJoueur: widget.nomJoueur),
                      ),
                      (route) => route.isFirst,
                    ),
                    icon: Icon(Icons.refresh),
                    label: Text('Choisir un autre quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7B2CBF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
