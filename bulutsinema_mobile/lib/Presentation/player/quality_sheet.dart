import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Application/player/player_bloc.dart';
import '../../Application/player/player_event.dart';
import '../../Application/player/player_state.dart';
import '../../Core/colors.dart';
import '../../Domain/movie_model.dart';
import '../../Domain/quality_model.dart';
import '../../Infrastructure/player_repository.dart';

class QualitySheet extends StatelessWidget {
  final Movie movie;
  const QualitySheet({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerBloc(PlayerRepository())..add(QualitiesRequested(movie)),
      child: _QualitySheetBody(movie: movie),
    );
  }
}

class _QualitySheetBody extends StatelessWidget {
  final Movie movie;
  const _QualitySheetBody({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: BlocConsumer<PlayerBloc, PlayerState>(
          listener: (context, state) {
            if (state is SentToTv) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ ${state.message}'), backgroundColor: AppColors.red),
              );
              Navigator.of(context).pop();
            } else if (state is SendError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('⚠ ${state.message}'), backgroundColor: const Color(0xFF333333)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KALİTE SEÇİN',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.displayTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  _buildBody(context, state),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.muted)),
                      child: const Text('✕ İptal Et', style: TextStyle(color: AppColors.muted)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PlayerState state) {
    if (state is QualitiesLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: AppColors.red)),
      );
    }
    if (state is QualitiesError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text('⚠ ${state.message}', style: const TextStyle(color: AppColors.muted)),
      );
    }

    QualityResult? result;
    bool sending = false;
    if (state is QualitiesReady) {
      result = state.result;
    } else if (state is SendingToTv) {
      result = state.result;
      sending = true;
    } else if (state is SendError) {
      result = state.result;
    }

    if (result == null) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: result.video.keys.map((quality) {
        return ElevatedButton(
          onPressed: sending ? null : () => context.read<PlayerBloc>().add(QualitySelected(quality)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF222222),
            side: const BorderSide(color: Color(0xFF444444)),
          ),
          child: sending
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(quality, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }
}
