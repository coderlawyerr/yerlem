// /// Lokasyon verilerini temsil eden model.
// /// Her konum: id, latitude, longitude, timestamp, notified ve geofenceName içerir.
// class LocationDataModel {
//   final int? id; // Veritabanı otomatik id verecek
//   final double latitude;
//   final double longitude;
//   final DateTime timestamp;
//   final bool? notified; // Bildirim gönderildi mi
//   final String? geofenceName; // Girilen dairenin ismi

//   LocationDataModel({this.id, required this.latitude, required this.longitude, required this.timestamp, this.notified, this.geofenceName});

//   /// Veritabanına kaydetmek için Map'e çevirme fonksiyonu.
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'latitude': latitude,
//       'longitude': longitude,
//       'timestamp': timestamp.toIso8601String(),
//       'notified': notified == true ? 1 : 0, // SQLite bool desteklemez
//       'geofenceName': geofenceName,
//     };
//   }

//   /// Veritabanından Map alıp modele dönüştürme fonksiyonu.
//   factory LocationDataModel.fromMap(Map<String, dynamic> map) {
//     return LocationDataModel(
//       id: map['id'],
//       latitude: map['latitude'],
//       longitude: map['longitude'],
//       timestamp: DateTime.parse(map['timestamp']),
//       notified: map.containsKey('notified') ? map['notified'] == 1 : null,
//       geofenceName: map['geofenceName'],
//     );
//   }

// }

class LocationDataModel {
  final int? id;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final bool? notified;
  final String? geofenceName;

  LocationDataModel({this.id, required this.latitude, required this.longitude, required this.timestamp, this.notified, this.geofenceName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'notified': notified == true ? 1 : 0,
      'geofenceName': geofenceName,
    };
  }

  factory LocationDataModel.fromMap(Map<String, dynamic> map) {
    return LocationDataModel(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: DateTime.parse(map['timestamp']),
      notified: map['notified'] == 1,
      geofenceName: map['geofenceName'],
    );
  }
}
