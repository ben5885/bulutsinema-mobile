import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Infrastructure/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    on<SearchSubmitted>(_onSubmitted);
    on<SearchCleared>((event, emit) => emit(SearchInitial()));
  }

  Future<void> _onSubmitted(SearchSubmitted event, Emitter<SearchState> emit) async {
    final term = event.term.trim();
    if (term.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final movies = await repository.search(term);
      emit(movies.isEmpty ? SearchEmpty() : SearchLoaded(movies));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
