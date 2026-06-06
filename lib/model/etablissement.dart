import 'package:latlong2/latlong.dart';

class Etablissement {
  final int etablissementId;
  final String nom;
  final String? ville;
  final String? voie;
  final LatLng? point;
  

  Etablissement({
    required this.etablissementId,
    required this.nom,
    this.ville,
    this.voie,
    this.point, required codepostal,
    
  });

  factory Etablissement.fromJson(Map<String, dynamic> json) {
    List? coords = json['coordonnees']?['coordinates'];
    return Etablissement(
      etablissementId: json['etablissement_id'] as int,
      nom: json['nom'] as String,
      ville: json['ville'] as String?,
      voie: json['voie'] as String?,
      point: coords != null ? LatLng(coords[1].toDouble(), coords[0].toDouble()) : null, codepostal: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'etablissement_id': etablissementId,
      'nom': nom,
      'ville': ville,
      'voie': voie,
      'lat': point?.latitude,
      'lng': point?.longitude,
    };
  }

  @override
  String toString() {
    return 'Etablissement{etablissementId: $etablissementId, nom: $nom, ville: $ville}';
  }
}
