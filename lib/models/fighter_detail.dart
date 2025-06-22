// lib/models/fighter_detail.dart

/// Detailed information about a fighter from the Octagon API.
class FighterDetail {
  final String name;           
  final String nickname;       
  final String category;       
  final String status;         
  final int wins;              
  final int losses;            
  final int draws;             
  final int age;               
  final double height;         
  final double weight;         
  final double reach;          
  final double legReach;       
  final String octagonDebut;   
  final String placeOfBirth;   
  final String trainsAt;       
  final String fightingStyle;  
  final String imgUrl;         

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

  /// Safely parse a String (or default to empty).
  static String _str(dynamic v) => v?.toString() ?? '';

  /// Safely parse an int from a String (or default to 0).
  static int _int(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  /// Safely parse a double from a String (or default to 0.0).
  static double _dbl(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0.0;

  factory FighterDetail.fromJson(Map<String, dynamic> json) {
    return FighterDetail(
      name:           _str(json['name']),
      nickname:       _str(json['nickname']),
      category:       _str(json['category']),
      status:         _str(json['status']),
      wins:           _int(json['wins']),
      losses:         _int(json['losses']),
      draws:          _int(json['draws']),
      age:            _int(json['age']),
      height:         _dbl(json['height']),
      weight:         _dbl(json['weight']),
      reach:          _dbl(json['reach']),
      legReach:       _dbl(json['legReach']),
      octagonDebut:   _str(json['octagonDebut']),
      placeOfBirth:   _str(json['placeOfBirth']),
      trainsAt:       _str(json['trainsAt']),
      fightingStyle:  _str(json['fightingStyle']),
      imgUrl:         _str(json['imgUrl']),
    );
  }
}
