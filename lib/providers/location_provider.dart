import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/location_model.dart';

class LocationProvider extends ChangeNotifier {
  Database? _database; // Nullable değişken

  /// Kaydedilen noktalar (tüm konum kayıtlari) ve geofence'ler
  List<LocationDataModel> locationHistory = [];
  List<GeofenceModel> geofences = [];

  /// Veritabanını aç ve tabloları oluştur
  Future<void> init() async {
    final path = join(await getDatabasesPath(), 'location_data.db');
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE location_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    latitude REAL,
    longitude REAL,
    timestamp TEXT,
    notified INTEGER,
    geofenceName TEXT
  )
''');
        /////cografı sınıur
        await db.execute('''
          CREATE TABLE geofences (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL,
            longitude REAL,
            radius INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE routes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,  -- id sütununu ekledik
            route_id INTEGER,
            latitude REAL,
            longitude REAL,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS routes'); // Mevcut tabloyu sil
          await db.execute('''
            CREATE TABLE routes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              route_id INTEGER,
              latitude REAL,
              longitude REAL,
              timestamp TEXT
            )
          '''); // Yeni tabloyu oluştur
        }
      },
    );

    await fetchLocationHistory();
    await fetchGeofences();
  }

  /// Tek bir konum kaydet
  Future<void> insertLocation(LocationDataModel location) async {
    await _database?.insert('location_data', location.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await fetchLocationHistory();
  }

  /// Tüm konum kaydını getir
  Future<void> fetchLocationHistory() async {
    final List<Map<String, dynamic>> maps = await _database!.query('location_data');
    locationHistory = maps.map((m) => LocationDataModel.fromMap(m)).toList();
    notifyListeners();
  }

  /// Geofence ekleme ve listeleme metodları
  Future<void> insertGeofence(GeofenceModel gf) async {
    await _database?.insert('geofences', gf.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await fetchGeofences();
  }

  Future<void> fetchGeofences() async {
    final List<Map<String, dynamic>> maps = await _database!.query('geofences');
    geofences = maps.map((m) => GeofenceModel.fromMap(m)).toList();
    notifyListeners();
  }

  /// Rota kaydetme (start/stop arasında biriken listeyi tabloya yaz)
  Future<void> saveRoute(int routeId, List<LocationDataModel> points) async {
    final batch = _database!.batch();
    for (final p in points) {
      final map = p.toMap()..['route_id'] = routeId;
      batch.insert('routes', map, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  /// Kayıtlı rota ID'lerini getir
  Future<List<int>> fetchRouteIds() async {
    final result = await _database!.rawQuery('SELECT DISTINCT route_id FROM routes');
    return result.map((r) => r['route_id'] as int).toList();
  }

  /// Bir rota için nokta listesini getir
  Future<List<LocationDataModel>> fetchRoute(int routeId) async {
    final maps = await _database!.query('routes', where: 'route_id = ?', whereArgs: [routeId]);
    return maps.map((m) => LocationDataModel.fromMap(m)).toList();
  }

  /// Haritada animasyonlu rota oynatma
  Future<void> animateRouteOnMap(GoogleMapController controller, List<LatLng> route) async {
    for (final point in route) {
      await controller.animateCamera(CameraUpdate.newLatLng(point));
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> playRouteAnimation(int routeId, GoogleMapController controller) async {
    final routePoints = await fetchRoute(routeId);

    for (int i = 0; i < routePoints.length; i++) {
      final point = routePoints[i];
      final latLng = LatLng(point.latitude, point.longitude);

      // Kamerayı animasyonla bu noktaya taşı
      controller.animateCamera(CameraUpdate.newLatLng(latLng));

      // Her noktada küçük bir gecikme
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> playRouteOnMap(GoogleMapController controller, List<LatLng> route) async {
    if (route.isEmpty) return;

    for (int i = 0; i < route.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300)); // animasyon hızı
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: route[i], zoom: 17)));
    }
  }
}

/// Geofence modeli
class GeofenceModel {
  final int? id;
  final double latitude;
  final double longitude;
  final int radius;

  GeofenceModel({this.id, required this.latitude, required this.longitude, required this.radius});

  Map<String, dynamic> toMap() => {'id': id, 'latitude': latitude, 'longitude': longitude, 'radius': radius};

  factory GeofenceModel.fromMap(Map<String, dynamic> m) =>
      GeofenceModel(id: m['id'] as int?, latitude: m['latitude'] as double, longitude: m['longitude'] as double, radius: m['radius'] as int);
}
