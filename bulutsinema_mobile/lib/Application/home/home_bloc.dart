import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Infrastructure/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(HomeLoadRequested event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final movies = await repository.fetchHome();
      emit(HomeLoaded(movies));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
