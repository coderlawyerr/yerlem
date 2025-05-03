// location_model.dart

/// Lokasyon verilerini temsil eden model.
/// Her konum: id, latitude, longitude ve timestamp içerir.
class LocationDataModel {
  final int? id; // Veritabanı otomatik id verecek
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationDataModel({this.id, required this.latitude, required this.longitude, required this.timestamp});

  /// Veritabanına kaydetmek için Map'e çevirme fonksiyonu.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(), // ISO formatta zaman
    };
  }

  /// Veritabanından Map alıp modele dönüştürme fonksiyonu.
  factory LocationDataModel.fromMap(Map<String, dynamic> map) {
    return LocationDataModel(id: map['id'], latitude: map['latitude'], longitude: map['longitude'], timestamp: DateTime.parse(map['timestamp']));
  }
}
