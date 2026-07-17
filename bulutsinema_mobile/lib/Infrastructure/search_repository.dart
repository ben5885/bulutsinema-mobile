import '../Core/api_client.dart';
import '../Domain/movie_model.dart';

class SearchRepository {
  Future<List<Movie>> search(String term) async {
    final json = await ApiClient.instance.getJson('/api/search', query: {'q': term});
    final list = (json['movies'] as List?) ?? [];
    return list.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }
}
