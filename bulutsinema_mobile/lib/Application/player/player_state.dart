import 'package:equatable/equatable.dart';
import '../../Domain/movie_model.dart';
import '../../Domain/quality_model.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();
  @override
  List<Object?> get props => [];
}

class PlayerIdle extends PlayerState {}

class QualitiesLoading extends PlayerState {}

class QualitiesReady extends PlayerState {
  final Movie movie;
  final QualityResult result;
  const QualitiesReady(this.movie, this.result);
  @override
  List<Object?> get props => [movie.id, result.video];
}

class QualitiesError extends PlayerState {
  final String message;
  const QualitiesError(this.message);
  @override
  List<Object?> get props => [message];
}

class SendingToTv extends PlayerState {
  final Movie movie;
  final QualityResult result;
  const SendingToTv(this.movie, this.result);
  @override
  List<Object?> get props => [movie.id];
}

class SentToTv extends PlayerState {
  final String message;
  const SentToTv(this.message);
  @override
  List<Object?> get props => [message];
}

class SendError extends PlayerState {
  final Movie movie;
  final QualityResult result;
  final String message;
  const SendError(this.movie, this.result, this.message);
  @override
  List<Object?> get props => [message];
}
