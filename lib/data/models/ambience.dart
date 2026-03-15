class Ambience {
  final String id;
  final String title;
  final String tag; // Focus, Calm, Sleep, Reset
  final int durationSeconds;
  final String description;
  final List<String> chips;
  final String thumbnailAsset;
  final String audioAsset;

  const Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.durationSeconds,
    required this.description,
    required this.chips,
    required this.thumbnailAsset,
    required this.audioAsset,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      durationSeconds: json['durationSeconds'] as int,
      description: json['description'] as String,
      chips: List<String>.from(json['chips'] ?? []),
      thumbnailAsset: json['thumbnailAsset'] as String,
      audioAsset: json['audioAsset'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tag': tag,
      'durationSeconds': durationSeconds,
      'description': description,
      'chips': chips,
      'thumbnailAsset': thumbnailAsset,
      'audioAsset': audioAsset,
    };
  }
}
