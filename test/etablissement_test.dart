import 'dart:convert';
import 'package:acteurs/model/etablissement.dart';
import 'package:acteurs/repository/etablissement_repository.dart';
import 'package:acteurs/service/etablissement_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {

  group("Classe Etablissement", () {
    test("Conversion JSON", () {
      String chaine = """
{
    "etablissement_id": 31,
    "nom": "UGC NORMANDIE",
    "voie": "116 AVENUE DES CHAMPS ELYSEES",
    "codepostal": null,
    "ville": "Paris 8e Arrondissement",
    "ecrans": 4,
    "fauteuils": 1533,
    "coordonnees": {
      "type": "Point",
      "crs": {
        "type": "name",
        "properties": {
          "name": "EPSG:4326"
        }
      },
      "coordinates": [2.300938, 48.872265]
    },
    "created_at": "2026-05-26T08:25:45.372005+02:00",
    "updated_at": null
  }
      """;

      Etablissement result = Etablissement.fromJson(jsonDecode(chaine));

      expect(result.etablissementId, 31);
      expect(result.nom, "UGC NORMANDIE");
      expect(result.voie, "116 AVENUE DES CHAMPS ELYSEES");
      expect(result.ville, "Paris 8e Arrondissement");
    });

    test("Appel API", () async {
      final bounds = LatLngBounds(
        LatLng(47.5, 6.5),
        LatLng(48.5, 7.5),
      );
      // final result = await fetchEtablissements(bounds);

      // expect(result, isNotEmpty);
    });

    test('Repository', () async {
      final bounds = LatLngBounds(
        LatLng(48.8, 2.2),
        LatLng(48.95, 2.45),
      );
      final repository = EtablissementRepository();
      final result = await repository.getEtablissements(bounds);

      // expect(result, isNotEmpty);
      for (int i = 0; i < result.length - 1; i++) {
        expect(result[i].nom.compareTo(result[i + 1].nom) <= 0, true);
      }
    });
  });

}
