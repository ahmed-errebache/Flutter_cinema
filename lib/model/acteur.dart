class Acteur {
    final int personneId; // final pas de fonction setter d'écriture. Impossible de modifier en dehors du constructeur
    final String nom;
    final String metaphone;
    final DateTime naissance;
    final int? age;
    final DateTime? deces; // ? Propriété nullable 
    final String nationalite;
    final String drapeauUnicode;
    final int nbFilm;
    final double popularite;

    // Constructeur avec initialisation directe des propriétés (this.nom = nom)
    Acteur({
      required this.personneId, // required : obligatoire car non nullable
      required this.nom,
      required this.metaphone,
      required this.naissance,
      this.age,
      this.deces,
      required this.nationalite,
      required this.drapeauUnicode,
      required this.nbFilm,
      required this.popularite
    });

    factory Acteur.fromJson(Map<String, dynamic> j) {
      return Acteur(
        personneId: j['personne_id'] as int,
        nom: j['nom'] as String,
        metaphone: j['metaphone'] as String,
        naissance: DateTime.parse(j['naissance'] as String),
        deces: j['deces'] != null ? DateTime.parse(j['deces'] as String) : null,
        age:  j['age'] != null ? j['age'] as int : null,
        nationalite: j['nationalite'] as String,
        drapeauUnicode: j['drapeau_unicode'] as String,
        popularite: (j['popularite'] as num).toDouble(),
        nbFilm: j['nb_film'] as int
      );
    }

    @override
    String toString() {
      return "$nom a fait $nbFilm films";
    }
}