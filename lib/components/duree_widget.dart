import 'package:flutter/material.dart';

class DureeWidget extends StatelessWidget {
  final int duree;
  final int? annee;

  const DureeWidget({super.key, required this.duree, this.annee});

  String get _formatee {
    final h = duree ~/ 60;
    final m = duree % 60;
    return h > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${m}min';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 13, color: Colors.grey[500]),
        SizedBox(width: 3),
        Text(
          annee != null ? '$_formatee  •  $annee' : _formatee,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }
}
