import 'package:acteurs/model/acteur.dart';
import 'package:acteurs/repository/acteur_repository.dart';
import 'package:acteurs/view/role_view.dart';
import 'package:custom_cached_image/custom_cached_image.dart';
import 'package:flutter/material.dart';

class ActeurView extends StatefulWidget {
  const ActeurView({super.key});

  @override
  State<StatefulWidget> createState() => _ActeurViewState();
}

class _ActeurViewState extends State<ActeurView> {
  final ActeurRepository _repository = ActeurRepository();
  late Future<List<Acteur>> _futurActeurs;

  @override
  void initState() {
    super.initState();
    _futurActeurs = _repository.getActeurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 0, 221, 255), Color.fromARGB(255, 0, 53, 72)],
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
              )
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Text(
                  'Liste des acteurs',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, offset: Offset(1, 2), blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _futurActeurs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun acteur trouvé"));
                }
                final acteurs = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: acteurs.length,
                  itemBuilder: (context, index) => _acteurCard(context, acteurs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _acteurCard(BuildContext context, Acteur acteur) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoleView(
              personId: acteur.personneId,
              nomActeur: acteur.nom,
              drapeauUnicode: acteur.drapeauUnicode,
              age: acteur.age,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ClipOval(
                child: CustomCachedImage(
                  imageUrl: "https://img.neotech.fr/cgi/images/tr:quality=50/cinema%2fprofiles%2f${acteur.personneId}.jpg",
                  width: 60,
                  height: 60,
                  borderRadius: 30,
                  fit: BoxFit.cover,
                  errorWidget: Image.asset("assets/images/profile.jpg"),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(acteur.nom, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Text(acteur.drapeauUnicode, style: TextStyle(fontSize: 16)),
                        SizedBox(width: 6),
                        Text(
                          acteur.age != null ? "${acteur.age} ans" : _formatDeces(acteur),
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF7B2CBF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${acteur.nbFilm} films",
                        style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDeces(Acteur acteur) {
    final naissance = "${acteur.naissance.year}";
    final deces = acteur.deces != null ? "${_moisAbrege(acteur.deces!.month)} ${acteur.deces!.year}" : "";
    return "né $naissance${deces.isNotEmpty ? ' · $deces' : ''}";
  }

  String _moisAbrege(int mois) {
    const moisList = ['jan.', 'fév.', 'mar.', 'avr.', 'mai', 'juin', 'juil.', 'août', 'sep.', 'oct.', 'nov.', 'déc.'];
    return moisList[mois - 1];
  }
}
