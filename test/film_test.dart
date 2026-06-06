// // import 'dart:convert';
// import 'dart:math';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:td1/model/film.dart';

// void main() {
//   group('Test Film', () {
//     test('conversion JSON', () {
//       final chaine = """
//     {
//     "film_id":5,"titre":"Groom Service","titre_original":"Four Rooms","annee":1995,"sortie":"1995-12-09","duree":98,"serie_id":null,"slogan":null,"pays":["us"],"created_at":"2026-05-21T09:12:55+02:00","updated_at":null
//     }
//   }
//       """;
//       final result = Film.fromRawJson((chaine));

//       final attendu = Film(
//         filmId: 5,
//         titre: "Groom Service",
//         titreOriginal: "Four Rooms",
//         annee: 1995,
//         sortie: "1995-12-09",
//         duree: 98,
//         serieId: null,
//         slogan: null,
//         pays: ["us"],
//         createdAt: "2026-05-21T09:12:55+02:00",
//         updatedAt: null
//       );

//       expect(result.filmId, 5);
//       expect(result.titre, "Groom Service");
//       expect(result, attendu);
//     });
//   });
// }