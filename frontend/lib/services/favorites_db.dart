import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_fighter.dart';

class FavoritesDb {
  static final FavoritesDb _instance = FavoritesDb._internal();
  factory FavoritesDb() => _instance;
  FavoritesDb._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id TEXT PRIMARY KEY, name TEXT, imgUrl TEXT, placeOfBirth TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE favorites ADD COLUMN placeOfBirth TEXT',
          );
        }
      },
    );
  }

  Future<void> addFavorite(FavoriteFighter fighter) async {
    final dbClient = await db;
    await dbClient.insert(
      'favorites',
      fighter.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final dbClient = await db;
    await dbClient.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FavoriteFighter>> getFavorites() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('favorites');
    return maps.map((map) => FavoriteFighter.fromMap(map)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
