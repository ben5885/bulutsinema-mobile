import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SourceLogoBadge extends StatelessWidget {
  final String logoUrl;
  final double size;
  const SourceLogoBadge({super.key, required this.logoUrl, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Opacity(
        opacity: 0.95,
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          width: size,
          height: size,
          fit: BoxFit.contain,
          // Logo yüklenemezse sessizce hiçbir şey gösterme — poster bozulmasın.
          errorWidget: (context, url, error) => const SizedBox.shrink(),
          placeholder: (context, url) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
