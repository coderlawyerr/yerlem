import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // LatLng için

class DBHelper {
  static Database? _database;

  // Veritabanı nesnesini getirir
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('locations.db');
    return _database!;
  }

  // Veritabanını başlatır
  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Veritabanı klasör yolu
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Veritabanı oluşturulurken çalışır
  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL,
        longitude REAL,
        timestamp TEXT
      )
    ''');
  }

  // Yeni konum kaydeder
  static Future<void> insertLocation(LatLng position) async {
    final db = await database;

    await db.insert('locations', {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Tüm kayıtlı konumları getirir
  static Future<List<LatLng>> getAllLocations() async {
    final db = await database;
    final result = await db.query('locations');

    return result.map((e) => LatLng(e['latitude'] as double, e['longitude'] as double)).toList();
  }

  // Veritabanını temizler (İstersen kullanırız)
  static Future<void> clearLocations() async {
    final db = await database;
    await db.delete('locations');
  }
}
