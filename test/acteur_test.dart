// import 'package:flutter_test/flutter_test.dart';
// import 'package:td1/model/acteur.dart';

// void main() {
//   group('Test Acteur', () {
//     test('conversion JSON', () {
//       final chaine = """
//     {
//     "personne_id":1003,"nom":"Jean Reno","metaphone":"JNRN","naissance":"1948-07-30","age":77,"deces":null,"nationalite":"fr","drapeau_unicode":"🇫🇷","nb_film":10,"popularite":144.789
//     }
//       """;
//       final result = Acteur.fromRawJson((chaine));

//       final attendu = Acteur(
//         personneId: 1003,
//         nom: "Jean Reno", metaphone: "JNRN", naissance: DateTime.parse("1948-07-30"), age: 77, deces: null, nationalite: "fr", drapeauUnicode: "🇫🇷", nbFilm: 10, popularite: 144.789,
//       );

//       expect(result.personneId, 1003);
//       expect(result.nom, "Jean Reno");
//       expect(result, attendu);
//     });
//   });
// }