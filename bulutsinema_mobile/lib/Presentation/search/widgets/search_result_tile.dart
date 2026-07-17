import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../Core/colors.dart';
import '../../../Domain/movie_model.dart';

class SearchResultTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const SearchResultTile({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: movie.poster.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: movie.poster,
                width: 50,
                height: 74,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(width: 50, height: 74, color: AppColors.surface),
                errorWidget: (context, url, error) =>
                    Container(width: 50, height: 74, color: AppColors.surface),
              )
            : Container(width: 50, height: 74, color: AppColors.surface),
      ),
      title: Text(
        movie.displayTitle,
        style: const TextStyle(color: Colors.white),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        [
          if (movie.year.isNotEmpty) movie.year,
          if (movie.rating.isNotEmpty) '⭐ ${movie.rating}',
        ].join(' · '),
        style: const TextStyle(color: AppColors.muted, fontSize: 12),
      ),
      trailing: movie.is4K
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                '4K',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
              ),
            )
          : null,
    );
  }
}
