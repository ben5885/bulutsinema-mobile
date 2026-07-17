import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Infrastructure/player_repository.dart';
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayerRepository repository;

  PlayerBloc(this.repository) : super(PlayerIdle()) {
    on<QualitiesRequested>(_onQualitiesRequested);
    on<QualitySelected>(_onQualitySelected);
    on<PlayerReset>((event, emit) => emit(PlayerIdle()));
  }

  Future<void> _onQualitiesRequested(
      QualitiesRequested event, Emitter<PlayerState> emit) async {
    emit(QualitiesLoading());
    try {
      final result = await repository.fetchQualities(event.movie);
      emit(QualitiesReady(event.movie, result));
    } catch (e) {
      emit(QualitiesError(e.toString()));
    }
  }

  Future<void> _onQualitySelected(
      QualitySelected event, Emitter<PlayerState> emit) async {
    final current = state;
    if (current is! QualitiesReady) return;
    emit(SendingToTv(current.movie, current.result));
    try {
      final message =
          await repository.sendToTv(movie: current.movie, quality: event.quality);
      emit(SentToTv(message));
    } catch (e) {
      emit(SendError(current.movie, current.result, e.toString()));
    }
  }
}
