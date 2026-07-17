import '../Core/api_client.dart';
import '../Domain/movie_model.dart';
import '../Domain/quality_model.dart';

class PlayerRepository {
  Future<QualityResult> fetchQualities(Movie movie) async {
    final json = await ApiClient.instance.postJson(
      '/api/qualities',
      {
        'id': movie.id,
        'url': movie.url,
        'referer': movie.referer,
        'ua': movie.ua,
        'title': movie.title,
      },
      timeout: const Duration(seconds: 60),
    );
    return QualityResult.fromJson(json as Map<String, dynamic>);
  }

  Future<String> sendToTv({required Movie movie, required String quality}) async {
    final json = await ApiClient.instance.postJson(
      '/api/play',
      {
        'id': movie.id,
        'quality': quality,
        'referer': movie.referer.isNotEmpty ? movie.referer : 'https://vidmoxy.net/',
      },
      timeout: const Duration(seconds: 30),
    );
    return (json as Map)['message']?.toString() ?? 'Gönderildi';
  }
}
