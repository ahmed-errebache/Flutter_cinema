import 'package:acteurs/view/acteur_view.dart';
import 'package:acteurs/view/carte_view.dart';
import 'package:acteurs/view/role_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:acteurs/view/quiz_accueil_view.dart';
import 'package:acteurs/components/home_button.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 60, bottom: 40),
            decoration : BoxDecoration(
              gradient: LinearGradient(
                 colors: [Color(0xFF7B2CBF), Color(0xff240046)],
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
          child :
            Column(
              children :
              [
                Text('PWA cinéma' , style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500 , color: Colors.white , shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(1, 2),
                    blurRadius: 4,
                  )
                ]),),
                SvgPicture.asset('assets/images/cinema.svg' , width: 300, height: 300),
              ]
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            
            children: [
              
              HomeButton(icon: Icons.location_on , route: MaterialPageRoute(builder: (_) => CarteView())),
              HomeButton(icon: Icons.theater_comedy , route: MaterialPageRoute(builder: (_) => ActeurView())),
              HomeButton(icon: Icons.quiz, route: MaterialPageRoute(builder: (_) => QuizAccueilView())),
              HomeButton(icon: Icons.theaters , route: MaterialPageRoute(builder: (_) => ActeurView())),


            ],
          )
        ],
      ),
    );
  }
}