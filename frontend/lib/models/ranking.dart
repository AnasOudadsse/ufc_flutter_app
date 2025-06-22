import 'champion.dart';
import 'fighter_summary.dart';

/// Represents one MMA ranking category (e.g. “Flyweight” or “Men’s Pound-for-Pound Top Rank”).
class Ranking {
  /// API identifier, e.g. "flyweight" or "mens-pound-for-pound-top-rank".
  final String id;
  /// Human-readable name, e.g. "Flyweight".
  final String categoryName;
  /// Current champion of the category.
  final Champion champion;
  /// List of fighters in this category (id & name).
  final List<FighterSummary> fighters;

  Ranking({
    required this.id,
    required this.categoryName,
    required this.champion,
    required this.fighters,
  });

  /// Creates a Ranking from JSON.
  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      id: json['id'] as String,
      categoryName: json['categoryName'] as String,
      champion: Champion.fromJson(json['champion'] as Map<String, dynamic>),
      fighters: (json['fighters'] as List<dynamic>)
          .map((item) => FighterSummary.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}