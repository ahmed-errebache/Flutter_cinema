import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double? votes;
  final double starSize;
  final Color color;

  const StarRating({
    super.key,
    required this.votes,
    this.starSize = 18,
    this.color = const Color.fromARGB(255, 255, 174, 22),
  });

  @override
  Widget build(BuildContext context) {
    final double note = (votes ?? 0) / 2;
    final double totalWidth = starSize * 5;
    return SizedBox(
      width: totalWidth,
      height: starSize,
      child: Stack(
        children: [
          Row(children: List.generate(5, (_) => Icon(Icons.star, size: starSize, color: Colors.grey[300]))),
          ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: note / 5,
              child: Row(children: List.generate(5, (_) => Icon(Icons.star, size: starSize, color: color))),
            ),
          ),
        ],
      ),
    );
  }
}
