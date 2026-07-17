import '../../Domain/movie_model.dart';

abstract class PlayerEvent {}

class QualitiesRequested extends PlayerEvent {
  final Movie movie;
  QualitiesRequested(this.movie);
}

class QualitySelected extends PlayerEvent {
  final String quality;
  QualitySelected(this.quality);
}

class PlayerReset extends PlayerEvent {}
