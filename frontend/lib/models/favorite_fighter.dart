class FavoriteFighter {
  final String id;
  final String name;
  final String imgUrl;
  final String placeOfBirth;

  FavoriteFighter({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.placeOfBirth,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'imgUrl': imgUrl,
    'placeOfBirth': placeOfBirth,
  };

  factory FavoriteFighter.fromMap(Map<String, dynamic> map) => FavoriteFighter(
    id: map['id'],
    name: map['name'],
    imgUrl: map['imgUrl'],
    placeOfBirth: map['placeOfBirth'] ?? '',
  );
}
