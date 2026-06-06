import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/film.dart';

Future<List<Film>> fetchFilms() async
{
  final response = await http.get(
    Uri.parse('https://api.neotech.fr/films')
);
if (response.statusCode == 200)
{
    final List tableau = jsonDecode(response.body);
    // chaque élément du tableau est un json qui représente un acteur, on utilise la méthode fromJson pour convertir chaque json en un objet Acteur
    return tableau.map((json) => Film.fromJson(json)).toList();
  }
else
{
    return [];
  }

  // print(response);
}

Future<Film> fetchFilm(int filmId) async
{
  final response = await http.get(
    Uri.parse('https://api.neotech.fr/films?film_id=eq.$filmId&select=*,votes(moyenne,votants),resumes(resume),genres(*),motscles(*),equipes(role,alias,ordre,personnes(personne_id,prenom,nom)),productions(societes(societe))')
);
if (response.statusCode == 200)
{
    final List tableau = jsonDecode(response.body);
    // chaque élément du tableau est un json qui représente un acteur, on utilise la méthode fromJson pour convertir chaque json en un objet Acteur
    return Film.fromJson(tableau[0]);
  }
else
{
    throw Exception("Erreur dans le service ");
  }

  // print(response);
}
