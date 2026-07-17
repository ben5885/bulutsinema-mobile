import 'package:flutter/material.dart';
import '../../Core/colors.dart';
import '../../Domain/movie_model.dart';

class QualityBadge extends StatelessWidget {
  final SourceBadge badge;
  const QualityBadge({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final isFourK = badge == SourceBadge.fourK;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isFourK ? AppColors.red : const Color(0xFF1F77E0),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        isFourK ? '4K' : 'HD',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
