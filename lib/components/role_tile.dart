import 'package:acteurs/components/duree_widget.dart';
import 'package:acteurs/components/star_rating.dart';
import 'package:acteurs/model/role.dart';
import 'package:custom_cached_image/custom_cached_image.dart';
import 'package:flutter/material.dart';

class RoleTile extends StatelessWidget {
  final Role role;
  final VoidCallback onTap;

  const RoleTile({super.key, required this.role, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: CustomCachedImage(
                imageUrl: "https://img.neotech.fr/cgi/images/tr:quality=50/cinema%2fposters%2f${role.filmId}.jpg",
                width: 80,
                height: 110,
                borderRadius: 0,
                fit: BoxFit.cover,
                errorWidget: Image.asset("assets/images/profile.jpg"),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(role.titre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 4),
                    Text(role.alias, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    SizedBox(height: 6),
                    StarRating(votes: role.votes),
                    SizedBox(height: 6),
                    DureeWidget(duree: role.duree, annee: role.annee),
                    if (role.genres.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        role.genres.join(' • '),
                        style: TextStyle(fontSize: 11, color: Color(0xFF7B2CBF), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
