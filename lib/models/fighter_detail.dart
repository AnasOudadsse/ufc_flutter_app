/// Detailed information about a fighter from the Octagon API.
class FighterDetail {
  final String name;           // Full name
  final String nickname;       // Fighter’s nickname
  final String category;       // Division name
  final String status;         // "Active" or "Retired"
  final int wins;              // Number of wins
  final int losses;            // Number of losses
  final int draws;             // Number of draws
  final int age;               // Age in years
  final double height;         // Height in inches
  final double weight;         // Weight in pounds
  final double reach;          // Reach in inches
  final double legReach;       // Leg reach in inches
  final String octagonDebut;   // Date of Octagon debut as raw string
  final String placeOfBirth;   // Fighter’s place of birth
  final String trainsAt;       // Training facility
  final String fightingStyle;  // Fighting style
  final String imgUrl;         // URL to fighter’s image

  FighterDetail({
    required this.name,
    required this.nickname,
    required this.category,
    required this.status,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.age,
    required this.height,
    required this.weight,
    required this.reach,
    required this.legReach,
    required this.octagonDebut,
    required this.placeOfBirth,
    required this.trainsAt,
    required this.fightingStyle,
    required this.imgUrl,
  });

  /// Creates a FighterDetail from JSON.
  factory FighterDetail.fromJson(Map<String, dynamic> json) {
    return FighterDetail(
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      wins: int.parse(json['wins'] as String),
      losses: int.parse(json['losses'] as String),
      draws: int.parse(json['draws'] as String),
      age: int.parse(json['age'] as String),
      height: double.parse(json['height'] as String),
      weight: double.parse(json['weight'] as String),
      reach: double.parse(json['reach'] as String),
      legReach: double.parse(json['legReach'] as String),
      octagonDebut: json['octagonDebut'] as String,
      placeOfBirth: json['placeOfBirth'] as String,
      trainsAt: json['trainsAt'] as String,
      fightingStyle: json['fightingStyle'] as String,
      imgUrl: json['imgUrl'] as String,
    );
  }
}
