import 'package:acteurs/components/role_tile.dart';
import 'package:acteurs/model/role.dart';
import 'package:acteurs/repository/role_repository.dart';
import 'package:acteurs/view/film_view.dart';
import 'package:custom_cached_image/custom_cached_image.dart';
import 'package:flutter/material.dart';

class RoleView extends StatefulWidget {
  final int personId;
  final String nomActeur;
  final String drapeauUnicode;
  final int? age;

  const RoleView({super.key, required this.personId, required this.nomActeur, required this.drapeauUnicode, this.age});

  @override
  State<StatefulWidget> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  final RoleRepository _repository = RoleRepository();
  late Future<List<Role>> _futurRoles;

  @override
  void initState() {
    super.initState();
    _futurRoles = _repository.getRoles(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 255, 8, 0), Color.fromARGB(255, 78, 2, 2)],
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
                ClipOval(
                  child: CustomCachedImage(
                    imageUrl: "https://img.neotech.fr/cgi/images/tr:quality=80/cinema%2fprofiles%2f${widget.personId}.jpg",
                    width: 90,
                    height: 90,
                    borderRadius: 45,
                    fit: BoxFit.cover,
                    errorWidget: Image.asset("assets/images/profile.jpg"),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.nomActeur,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, offset: Offset(1, 2), blurRadius: 4)],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.drapeauUnicode, style: TextStyle(fontSize: 28)),
                    SizedBox(width: 5),
                    Text(
                      "${widget.age ?? '?'} ans",
                      style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _futurRoles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun rôle trouvé"));
                }
                final roles = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: roles.length,
                  itemBuilder: (context, index) => RoleTile(
                    role: roles[index],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FilmView(filmId: roles[index].filmId, nomFilm: roles[index].titre))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
