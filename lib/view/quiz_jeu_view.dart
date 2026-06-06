import 'dart:async';
import 'package:acteurs/model/question.dart';
import 'package:acteurs/model/quiz.dart';
import 'package:acteurs/view/quiz_score_view.dart';
import 'package:flutter/material.dart';

class QuizJeuView extends StatefulWidget {
  final Quiz quiz;
  final List<Question> questions;
  final String nomJoueur;

  const QuizJeuView({
    super.key,
    required this.quiz,
    required this.questions,
    required this.nomJoueur,
  });

  @override
  State<QuizJeuView> createState() => _QuizJeuViewState();
}

class _QuizJeuViewState extends State<QuizJeuView> {
  int _index = 0;
  int _score = 0;
  String? _reponseChoisie;
  late List<String> _options;

  static const int _dureeMax = 15;
  int _tempsRestant = _dureeMax;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _melangerOptions();
    _demarrerTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _melangerOptions() {
    final q = widget.questions[_index];
    _options = [...q.autres, q.reponse]..shuffle();
  }

  void _demarrerTimer() {
    _timer?.cancel();
    _tempsRestant = _dureeMax;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_tempsRestant == 0) {
        timer.cancel();
        _tempsEcoule();
      } else {
        setState(() => _tempsRestant--);
      }
    });
  }

  void _tempsEcoule() {
    setState(() => _reponseChoisie = '__timeout__');
    Future.delayed(Duration(milliseconds: 900), () {
      if (!mounted) return;
      _passerQuestion();
    });
  }

  void _repondre(String reponse) {
    if (_reponseChoisie != null) return;
    _timer?.cancel();
    final bonne = widget.questions[_index].reponse;
    setState(() {
      _reponseChoisie = reponse;
      if (reponse == bonne) {
        _score += 10 + _tempsRestant; // base 10 + bonus vitesse (max 25)
      }
    });

    Future.delayed(Duration(milliseconds: 900), () {
      if (!mounted) return;
      _passerQuestion();
    });
  }

  void _passerQuestion() {
    if (_index + 1 < widget.questions.length) {
      setState(() {
        _index++;
        _reponseChoisie = null;
        _melangerOptions();
      });
      _demarrerTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScoreView(
            score: _score,
            scoreMax: widget.questions.length * (10 + _dureeMax),
            nbBonnes: _score ~/ 10,
            total: widget.questions.length,
            nomJoueur: widget.nomJoueur,
            quiz: widget.quiz,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_index];
    final total = widget.questions.length;
    final timerRatio = _tempsRestant / _dureeMax;
    final timerColor = timerRatio > 0.5
        ? Colors.green
        : timerRatio > 0.25
            ? Colors.orange
            : Colors.red;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 20),
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
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Text(
                  widget.quiz.quiz,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Text(
                  'Question ${_index + 1} / $total',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(
                    value: (_index + 1) / total,
                    backgroundColor: Colors.white30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.timer, color: timerColor),
                SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: timerRatio,
                    backgroundColor: Colors.grey[200],
                    color: timerColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '$_tempsRestant s',
                  style: TextStyle(fontWeight: FontWeight.bold, color: timerColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8),
                  Text(
                    question.question,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ..._options.map((option) => _boutonReponse(option, question.reponse)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _boutonReponse(String option, String bonneReponse) {
    Color couleur = Color(0xFF7B2CBF);
    if (_reponseChoisie != null) {
      if (option == bonneReponse) couleur = Colors.green;
      else if (option == _reponseChoisie) couleur = Colors.red;
      else couleur = Colors.grey;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: _reponseChoisie == null ? () => _repondre(option) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: couleur,
          disabledBackgroundColor: couleur,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(option, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
