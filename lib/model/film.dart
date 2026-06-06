class EquipeMembre {
  final String role;
  final String alias;
  final int ordre;
  final int? personneId;
  final String prenom;
  final String nom;

  const EquipeMembre({
    required this.role,
    required this.alias,
    required this.ordre,
    this.personneId,
    required this.prenom,
    required this.nom,
  });

  String get nomComplet => '$prenom $nom'.trim();

  factory EquipeMembre.fromJson(Map<String, dynamic> json) {
    final personne = json['personnes'] as Map<String, dynamic>? ?? {};
    return EquipeMembre(
      role: json['role'] as String? ?? '',
      alias: json['alias'] as String? ?? '',
      ordre: json['ordre'] as int? ?? 0,
      personneId: personne['personne_id'] as int?,
      prenom: personne['prenom'] as String? ?? '',
      nom: personne['nom'] as String? ?? '',
    );
  }
}

class Film {
  final int filmId;
  final String titre;
  final String? titreOriginal;
  final int? annee;
  final String? sortie;
  final int? duree;
  final int? serieId;
  final String? slogan;
  final List<String> pays;
  final String? createdAt;
  final String? updatedAt;
  final double? votes;
  final int? votants;
  final List<String> genres;
  final List<String> motsCles;
  final String? resume;
  final List<EquipeMembre> equipes;
  final List<String> productions;

  Film({
    required this.filmId,
    required this.titre,
    this.titreOriginal,
    this.annee,
    this.sortie,
    this.duree,
    this.serieId,
    this.slogan,
    required this.pays,
    this.createdAt,
    this.updatedAt,
    this.votes,
    this.votants,
    this.genres = const [],
    this.motsCles = const [],
    this.resume,
    this.equipes = const [],
    this.productions = const [],
  });

  List<EquipeMembre> get acteurs =>
      equipes.where((e) => e.role.toUpperCase() == 'ACTEUR').toList()
        ..sort((a, b) => a.ordre.compareTo(b.ordre));

  List<EquipeMembre> get equipesTechniques =>
      equipes.where((e) => e.role.toUpperCase() != 'ACTEUR').toList()
        ..sort((a, b) => a.ordre.compareTo(b.ordre));

  factory Film.fromJson(Map<String, dynamic> json) {
    final votesJson = json['votes'];
    return Film(
      filmId: json['film_id'] as int,
      titre: json['titre'] as String,
      titreOriginal: json['titre_original'] as String?,
      annee: json['annee'] as int?,
      sortie: json['sortie'] as String?,
      duree: json['duree'] as int?,
      serieId: json['serie_id'] as int?,
      slogan: json['slogan'] as String?,
      pays: json['pays'] != null
          ? (json['pays'] as List).whereType<String>().toList()
          : [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      votes: votesJson != null ? (votesJson['moyenne'] as num?)?.toDouble() : null,
      votants: votesJson != null ? votesJson['votants'] as int? : null,
      genres: json['genres'] != null
          ? (json['genres'] as List)
              .map((x) => x['genre'] as String?)
              .whereType<String>()
              .toList()
          : [],
      motsCles: json['motscles'] != null
          ? (json['motscles'] as List)
              .map((x) => x['mot_cle'] as String?)
              .whereType<String>()
              .toList()
          : [],
      resume: json['resumes'] != null && (json['resumes'] as List).isNotEmpty
          ? (json['resumes'] as List).first['resume'] as String?
          : null,
      equipes: json['equipes'] != null
          ? (json['equipes'] as List).map((x) => EquipeMembre.fromJson(x)).toList()
          : [],
      productions: json['productions'] != null
          ? (json['productions'] as List)
              .where((x) => x['societes'] != null)
              .map((x) => x['societes']['societe'] as String?)
              .whereType<String>()
              .toList()
          : [],
    );
  }

  String get dureeFormatee {
    if (duree == null) return '';
    final h = duree! ~/ 60;
    final m = duree! % 60;
    return h > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${m}min';
  }

  @override
  String toString() => 'Film{filmId: $filmId, titre: $titre}';
}
