import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Application/home/home_bloc.dart';
import '../../Application/home/home_event.dart';
import '../../Application/home/home_state.dart';
import '../../Core/colors.dart';
import '../../Domain/movie_model.dart';
import '../player/quality_sheet.dart';
import '../shared/settings_sheet.dart';
import 'widgets/banner_widget.dart';
import 'widgets/poster_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeLoadRequested());
  }

  void _openPlayer(Movie movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => QualitySheet(movie: movie),
    );
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      builder: (_) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'BULUTSINEMA',
          style: TextStyle(
            color: AppColors.red,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is HomeError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<HomeBloc>().add(HomeLoadRequested()),
              onSettings: _openSettings,
            );
          }

          final movies = (state as HomeLoaded).movies;
          if (movies.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Kütüphane boş görünüyor. PC\'deki 3.m3u dosyasını kontrol et.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted),
                ),
              ),
            );
          }

          final withImage = movies.where((m) => m.displayImage.isNotEmpty).toList();
          final bannerMovie =
              withImage.isNotEmpty ? withImage[Random().nextInt(withImage.length)] : movies.first;

          final rows = <Widget>[];
          const chunkSize = 20;
          for (var i = 0; i < movies.length; i += chunkSize) {
            final part = movies.sublist(i, min(i + chunkSize, movies.length));
            final label = i == 0 ? 'Kütüphanem' : 'Devamı';
            rows.add(PosterRow(title: label, movies: part, onTap: _openPlayer));
          }

          return RefreshIndicator(
            color: AppColors.red,
            onRefresh: () async => context.read<HomeBloc>().add(HomeLoadRequested()),
            child: ListView(
              children: [
                HomeBanner(movie: bannerMovie, onPlay: () => _openPlayer(bannerMovie)),
                const SizedBox(height: 16),
                ...rows,
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onSettings;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: AppColors.muted, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 8),
            const Text(
              'PC\'de api_server.py çalışıyor mu ve telefon aynı ağda mı?',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                  child: const Text('Tekrar Dene'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: onSettings,
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.muted)),
                  child: const Text('Ayarlar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
