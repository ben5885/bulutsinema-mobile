import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);

  String get friendlyMessage {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['error'] != null) {
        return decoded['error'].toString();
      }
    } catch (_) {
      // gövde JSON değilse yut, generic mesaj kullan
    }
    return 'Sunucu hatası ($statusCode)';
  }

  @override
  String toString() => friendlyMessage;
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  String? _cachedBaseUrl;

  Future<String> getBaseUrl() async {
    if (_cachedBaseUrl != null) return _cachedBaseUrl!;
    final prefs = await SharedPreferences.getInstance();
    _cachedBaseUrl =
        prefs.getString(AppConstants.baseUrlPrefKey) ?? AppConstants.defaultBaseUrl;
    return _cachedBaseUrl!;
  }

  Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final clean = url.trim().replaceAll(RegExp(r'/+$'), '');
    await prefs.setString(AppConstants.baseUrlPrefKey, clean);
    _cachedBaseUrl = clean;
  }

  Future<dynamic> getJson(String path, {Map<String, String>? query}) async {
    final base = await getBaseUrl();
    var uri = Uri.parse('$base$path');
    if (query != null) {
      uri = uri.replace(queryParameters: query);
    }
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw ApiException(res.statusCode, res.body);
  }

  Future<dynamic> postJson(String path, Map<String, dynamic> body, {Duration? timeout}) async {
    final base = await getBaseUrl();
    final uri = Uri.parse('$base$path');
    final res = await http
        .post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body))
        .timeout(timeout ?? const Duration(seconds: 45));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw ApiException(res.statusCode, res.body);
  }
}
