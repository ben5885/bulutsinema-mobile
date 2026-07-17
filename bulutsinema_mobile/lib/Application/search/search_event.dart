abstract class SearchEvent {}

class SearchSubmitted extends SearchEvent {
  final String term;
  SearchSubmitted(this.term);
}

class SearchCleared extends SearchEvent {}
