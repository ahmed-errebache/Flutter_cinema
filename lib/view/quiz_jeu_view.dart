import 'package:acteurs/model/question.dart';
import 'package:acteurs/model/quiz.dart';
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

  @override
  void initState() {
    super.initState();
    _melangerOptions();
  }

  void _melangerOptions() {
    final q = widget.questions[_index];
    _options = [...q.autres, q.reponse]..shuffle();
  }

  void _repondre(String reponse) {
    if (_reponseChoisie != null) return;
    final bonne = widget.questions[_index].reponse;
    setState(() {
      _reponseChoisie = reponse;
      if (reponse == bonne) _score++;
    });

    Future.delayed(Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_index + 1 < widget.questions.length) {
        setState(() {
          _index++;
          _reponseChoisie = null;
          _melangerOptions();
        });
      } else {
        _afficherScore();
      }
    });
  }

  void _afficherScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Résultat'),
        content: Text(
          '${widget.nomJoueur} : $_score / ${widget.questions.length}',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: Text('Retour au menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_index];
    final total = widget.questions.length;

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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16),
                  Text(
                    question.question,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
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
