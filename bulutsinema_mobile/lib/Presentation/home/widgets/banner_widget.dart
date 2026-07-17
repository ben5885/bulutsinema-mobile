import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../Core/colors.dart';
import '../../../Domain/movie_model.dart';

class HomeBanner extends StatelessWidget {
  final Movie movie;
  final VoidCallback onPlay;

  const HomeBanner({super.key, required this.movie, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (movie.displayImage.isNotEmpty)
            CachedNetworkImage(
              imageUrl: movie.displayImage,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(color: AppColors.surface),
            )
          else
            Container(color: AppColors.surface),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.background],
                stops: [0.45, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.displayTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: onPlay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Oynat', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
