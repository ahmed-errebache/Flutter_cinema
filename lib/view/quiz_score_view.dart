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

class _QuizScoreViewState extends State<QuizScoreView> with TickerProviderStateMixin {
  final _progressService = QuizProgressService();

  late AnimationController _memeController;
  late AnimationController _scoreController;
  late Animation<double> _memeAnimation;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _progressService.saveScore(widget.quiz.quiz_id, widget.score);

    // Animation zoom élastique : part de 0, pop à 1.0 avec rebond
    _memeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    _memeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _memeController, curve: ElasticOutCurve(0.6)),
    );

    // Score qui s'incrémente de 0 jusqu'au score final
    _scoreController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _scoreAnimation = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOut),
    );

    _memeController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _scoreController.forward();
    });
  }

  @override
  void dispose() {
    _memeController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  String get _memeAsset {
    final ratio = widget.score / widget.scoreMax;
    if (ratio >= 0.8) return 'assets/images/meme_excellent.jpg';
    if (ratio >= 0.5) return 'assets/images/meme_bien.jpg';
    return 'assets/images/meme_effort.jpg';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mème avec animation zoom pop élastique
                AnimatedBuilder(
                  animation: _memeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _memeAnimation.value,
                      child: child,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      _memeAsset,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Column(
                  children: [
                    Text(
                      widget.nomJoueur,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    // Score qui s'incrémente
                    AnimatedBuilder(
                      animation: _scoreAnimation,
                      builder: (context, _) {
                        return Text(
                          '${_scoreAnimation.value}',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B2CBF),
                          ),
                        );
                      },
                    ),
                    Text(
                      'points sur ${widget.scoreMax}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${widget.nbBonnes} / ${widget.total} bonnes réponses',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),

                Text(
                  _mentionTexte,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _mentionColor,
                  ),
                ),

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
        ],
      ),
    );
  }
}
