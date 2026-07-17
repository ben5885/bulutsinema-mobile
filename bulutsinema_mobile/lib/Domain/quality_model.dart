class AudioTrack {
  final String groupId;
  final String lang;
  final String name;
  final String url;

  const AudioTrack({
    required this.groupId,
    required this.lang,
    required this.name,
    required this.url,
  });

  factory AudioTrack.fromJson(Map<String, dynamic> json) => AudioTrack(
        groupId: json['group_id']?.toString() ?? '',
        lang: json['lang']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
      );
}

class QualityResult {
  final String title;
  final String poster;
  final Map<String, String> video; // "1080p" -> stream url
  final List<AudioTrack> audio;

  const QualityResult({
    required this.title,
    required this.poster,
    required this.video,
    required this.audio,
  });

  factory QualityResult.fromJson(Map<String, dynamic> json) => QualityResult(
        title: json['title']?.toString() ?? '',
        poster: json['poster']?.toString() ?? '',
        video: Map<String, String>.from(
          (json['video'] as Map?)?.map((k, v) => MapEntry(k.toString(), v.toString())) ?? {},
        ),
        audio: ((json['audio'] as List?) ?? [])
            .map((e) => AudioTrack.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
