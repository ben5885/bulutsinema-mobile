class Movie {
  final int id;
  final String title;
  final String url;
  final String poster;
  final String banner;
  final String referer;
  final String ua;
  final String year;
  final String rating;

  const Movie({
    required this.id,
    required this.title,
    required this.url,
    required this.poster,
    required this.banner,
    required this.referer,
    required this.ua,
    required this.year,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
        title: json['title']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
        poster: json['poster']?.toString() ?? '',
        banner: json['banner']?.toString() ?? '',
        referer: json['referer']?.toString() ?? '',
        ua: json['ua']?.toString() ?? 'Mozilla/5.0',
        year: json['year']?.toString() ?? '',
        rating: json['rating']?.toString() ?? '',
      );

  bool get is4K => title.contains('[4K]');
  String get displayTitle => title.replaceAll(' [4K]', '').trim();
  String get displayImage => banner.isNotEmpty ? banner : poster;
}
