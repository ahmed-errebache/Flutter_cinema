import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/role.dart';

Future<List<Role>> fetchRoles() async {
  final response = await http.get(
    Uri.parse('https://api.neotech.fr/equipes?personne_id=eq.3&role=eq.acteur&select=alias,role,films(film_id, titre, annee, duree, genres(*),votes(*))')
  );

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map( (e) => Role.fromJson(e) ).toList();
  } else {
    return [];
  }
}