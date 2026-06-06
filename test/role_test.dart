import 'package:acteurs/repository/role_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:acteurs/model/role.dart';
import 'package:acteurs/service/role_service.dart';
void main() {

  group("Classe Role", () {
    test("Conversion JSON", () {
      String chaine = """
{ "alias":"Han Solo",
  "role":"acteur",
  "films": {
    "annee": 1977, 
    "duree": 121, 
    "titre": "La Guerre des étoiles", 
    "votes": null, 
    "genres": [
	  {"genre": "Aventure", "genre_id": 12}, 
	  {"genre": "Action", "genre_id": 28}, 
	  {"genre": "Science-Fiction", "genre_id": 878}
	 ], 
	"film_id": 11
	}
}
      """;

      Role result = Role.fromRawJson(chaine);

      Role origine = Role(
        alias: "Han Solo", 
        role: "acteur", 
        annee: 1977, 
        duree: 121, 
        votes: 0,
        titre: "La Guerre des étoiles", 
        genres: ["Aventure", "Action", "Science-Fiction"], 
        filmId: 11,
        );

      expect(result.alias, "Han Solo");
      expect(result, origine);
    });
  
    test("Appel API", () async {
      final result = await fetchRoles();

      expect(result, isNotEmpty);
      expect(result.length, 29);
      expect(result[5].titre, "Indiana Jones et la dernière croisade");
    });

    test('Repository', () async {
      final repository = RoleRepository();
      final result = await repository.getRoles(1);

      final resultNonNull = result.where((e) => e.votes != null);
      for (int i = 0; i < resultNonNull.length - 2; i++) {
        expect(result[i].votes! > result[i + 1].votes!, true);
      }
    });
  });

}