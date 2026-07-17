import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../Core/colors.dart';
import '../../../Domain/movie_model.dart';
import '../../shared/quality_badge.dart';
import '../../shared/source_logo_badge.dart';

class PosterRow extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final void Function(Movie) onTap;

  const PosterRow({
    super.key,
    required this.title,
    required this.movies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () => onTap(movie),
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: movie.poster.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: movie.poster,
                                  height: 180,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: AppColors.surface),
                                  errorWidget: (context, url, error) =>
                                      Container(color: AppColors.surface),
                                )
                              : Container(height: 180, width: 120, color: AppColors.surface),
                        ),
                        if (movie.sourceBadge != null)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: QualityBadge(badge: movie.sourceBadge!),
                          ),
                        if (movie.hasSourceLogo)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: SourceLogoBadge(logoUrl: movie.sourceLogo),
                          ),
                      ],
                    ),
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
