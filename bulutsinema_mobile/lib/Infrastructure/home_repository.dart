import '../Core/api_client.dart';
import '../Domain/movie_model.dart';

class HomeRepository {
  Future<List<Movie>> fetchHome() async {
    final json = await ApiClient.instance.getJson('/api/home');
    final list = (json['movies'] as List?) ?? [];
    return list.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }
}
