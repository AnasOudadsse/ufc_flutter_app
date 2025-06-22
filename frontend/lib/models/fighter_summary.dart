/// Minimal info for a fighter in a ranking list.
class FighterSummary {
  /// Fighter’s unique ID (e.g. "islam-makhachev").
  final String id;
  /// Fighter’s display name.
  final String name;

  FighterSummary({
    required this.id,
    required this.name,
  });

  /// Creates a FighterSummary from JSON.
  factory FighterSummary.fromJson(Map<String, dynamic> json) {
    return FighterSummary(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}