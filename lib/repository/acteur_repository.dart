import '../model/acteur.dart';
import '../service/acteur_service.dart';

class ActeurRepository {
  Future<List<Acteur>> getActeurs() async {
    final acteurs = await fetchActeurs();

    acteurs.sort((a, b) => a.nom.compareTo(b.nom));
    return acteurs;
  }
}