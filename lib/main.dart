import 'dart:convert';

import 'package:acteurs/view/carte_view.dart';
import 'package:acteurs/view/home_view.dart';
import 'package:acteurs/view/role_view.dart';
import 'package:flutter/material.dart';
import 'model/acteur.dart';
import 'view/acteur_view.dart';
void main() {

  //Déclaration de la variable a
  Acteur a;

  // Construction
  a = Acteur(
    personneId:  1003, 
    nationalite: "fr", 
    nbFilm: 10, 
    nom: "Jean Reno", 
    metaphone: "JNRN", 
    age: 77, 
    naissance: DateTime.parse("1948-07-30"), 
    drapeauUnicode: "🇫🇷", 
    popularite: 144.789);

  print(a);
  print(a.nom);
  //a.nom = "Inconnu"; // final impossible à modifier
  print(a.nom);

  String chaine = '''
  {
    "personne_id":31,
    "nom":"Tom Hanks",
    "metaphone":"TMHNKS",
    "naissance":"1956-07-09",
    "age":69,
    "nationalite":"us",
    "drapeau_unicode":"🇺🇸",
    "nb_film":21,
    "popularite":131.335
  }
 ''';

  Map<String, dynamic> j = jsonDecode(chaine);

  print(j);

  Acteur b = Acteur.fromJson(j);
    
  print(b);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}
