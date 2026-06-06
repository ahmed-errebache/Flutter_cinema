import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/acteur.dart';

Future<List<Acteur>> fetchActeurs() async {
  final response = await http.get(
    Uri.parse('https://api.neotech.fr/acteurs')
  );

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map( (e) => Acteur.fromJson(e) ).toList();
  } else {
    throw Exception("Erreur API");
  }
}