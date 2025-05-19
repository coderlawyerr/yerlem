

class GeofenceModel {
  final int? id;
  final double latitude;
  final double longitude;
  final int radius;

  GeofenceModel({this.id, required this.latitude, required this.longitude, required this.radius});

  Map<String, dynamic> toMap() {
    return {'id': id, 'latitude': latitude, 'longitude': longitude, 'radius': radius};
  }

  factory GeofenceModel.fromMap(Map<String, dynamic> map) {
    return GeofenceModel(id: map['id'], latitude: map['latitude'], longitude: map['longitude'], radius: map['radius']);
  }
}
