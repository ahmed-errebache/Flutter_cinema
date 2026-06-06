
import 'package:acteurs/view/carte_view.dart';
import 'package:flutter/material.dart';
class HomeButton extends StatelessWidget {
  final IconData icon;
  final MaterialPageRoute route;

  HomeButton({ super.key, required this.icon , required this.route});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
          Navigator.push(
            context,
            route,
          );
      },
      elevation: 2,
      fillColor: Color(0xff240046),
      padding: EdgeInsets.all(15),
      shape: CircleBorder(),
      child: Icon(icon, size: 32, color: Colors.white),
    );
  }
}