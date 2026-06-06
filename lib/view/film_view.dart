import 'package:acteurs/components/duree_widget.dart';
import 'package:acteurs/components/star_rating.dart';
import 'package:acteurs/model/film.dart';
import 'package:acteurs/repository/film_repository.dart';
import 'package:custom_cached_image/custom_cached_image.dart';
import 'package:flutter/material.dart';

class FilmView extends StatefulWidget {
  final int filmId;
  final String nomFilm;

  const FilmView({super.key, required this.filmId, required this.nomFilm});

  @override
  State<StatefulWidget> createState() => _FilmViewState();
}

class _FilmViewState extends State<FilmView> {
  final FilmRepository _repository = FilmRepository();
  late Future<Film> _futurFilm;

  @override
  void initState() {
    super.initState();
    _futurFilm = _repository.getFilm(widget.filmId);
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
                colors: [Color.fromARGB(255, 25, 0, 255), Color.fromARGB(255, 4, 1, 54)],
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
                  widget.nomFilm,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, offset: Offset(1, 2), blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Film>(
              future: _futurFilm,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text("Aucun film trouvé"));
                }
                return _filmDetail(snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filmDetail(Film film) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomCachedImage(
                  imageUrl: "https://img.neotech.fr/cgi/images/tr:quality=80/cinema%2fposters%2f${film.filmId}.jpg",
                  width: 110,
                  height: 160,
                  borderRadius: 0,
                  fit: BoxFit.cover,
                  errorWidget: Image.asset("assets/images/profile.jpg"),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${film.titre}${film.annee != null ? ' (${film.annee})' : ''}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    if (film.sortie != null)
                      Text(_formatDate(film.sortie!), style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    if (film.duree != null) ...[
                      SizedBox(height: 2),
                      DureeWidget(duree: film.duree!),
                    ],
                    SizedBox(height: 8),
                    if (film.genres.isNotEmpty)
                      Text(film.genres.join(', '), style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    SizedBox(height: 10),
                    if (film.votes != null) StarRating(votes: film.votes, starSize: 20),
                  ],
                ),
              ),
            ],
          ),
          if (film.resume != null && film.resume!.isNotEmpty) ...[
            SizedBox(height: 16),
            Text(film.resume!, style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5)),
          ],
          if (film.slogan != null && film.slogan!.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              '"${film.slogan}"',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[600]),
            ),
          ],
          if (film.acteurs.isNotEmpty) ...[
            SizedBox(height: 20),
            Text("Acteurs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: film.acteurs.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final a = film.acteurs[i];
                  return SizedBox(
                    width: 75,
                    child: Column(
                      children: [
                        ClipOval(
                          child: CustomCachedImage(
                            imageUrl: a.personneId != null
                                ? "https://img.neotech.fr/cgi/images/tr:quality=60/cinema%2fprofiles%2f${a.personneId}.jpg"
                                : "",
                            width: 60,
                            height: 60,
                            borderRadius: 30,
                            fit: BoxFit.cover,
                            errorWidget: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF7B2CBF),
                              child: Text(a.nomComplet.isNotEmpty ? a.nomComplet[0] : '?',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(a.nomComplet, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                        Text(a.alias, style: TextStyle(fontSize: 10, color: Colors.grey[500]), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          if (film.equipesTechniques.isNotEmpty) ...[
            SizedBox(height: 20),
            Text("Équipe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            ...film.equipesTechniques.map((e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Text(e.nomComplet, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  SizedBox(width: 8),
                  Text(e.role, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            )),
          ],
          if (film.productions.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(film.productions.join(', '), style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
          if (film.motsCles.isNotEmpty) ...[
            SizedBox(height: 20),
            Text("Mots-clés", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: film.motsCles.map((mot) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(mot, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String sortie) {
    try {
      final d = DateTime.parse(sortie);
      return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
    } catch (_) {
      return sortie;
    }
  }
}
