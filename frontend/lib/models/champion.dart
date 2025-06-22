/// Info about the champion of a category.
class Champion {
  /// Champion’s fighter ID.
  final String id;
  /// Champion’s full name.
  final String championName;

  Champion({
    required this.id,
    required this.championName,
  });

  /// Creates a Champion from JSON.
  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      id: json['id'] as String,
      championName: json['championName'] as String,
    );
  }
}