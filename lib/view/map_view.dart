// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:provider/provider.dart';
// import '../models/location_model.dart';
// import '../providers/location_provider.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _mapController;
//   final Location _locationService = Location();
//   bool _isRecording = false;
//   int? _currentRouteId;
//   List<LatLng> _routePoints = [];
//   LatLng? _currentLocation;
//   Marker? _currentMarker;
//   @override
//   void initState() {
//     super.initState();
//     _initLocationTracking();
//   }

//   Future<void> _initLocationTracking() async {
//     var permission = await _locationService.hasPermission();
//     if (permission != PermissionStatus.granted) {
//       permission = await _locationService.requestPermission();
//     }

//     if (permission == PermissionStatus.granted) {
//       _locationService.onLocationChanged.listen((LocationData data) {
//         final newPoint = LatLng(data.latitude!, data.longitude!);
//         setState(() {
//           _currentLocation = newPoint;
//           if (_isRecording) {
//             _routePoints.add(newPoint);
//           }
//         });

//         _mapController?.animateCamera(CameraUpdate.newLatLng(newPoint));
//         _checkProximityAndNotify(newPoint);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konum izni verilmedi!')));
//     }
//   }

//   void _checkProximityAndNotify(LatLng currentPosition) {
//     final provider = Provider.of<LocationProvider>(context, listen: false);
//     for (var gf in provider.geofences) {
//       final distance = _calculateDistance(currentPosition.latitude, currentPosition.longitude, gf.latitude, gf.longitude);
//       if (distance <= gf.radius) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("'${gf.id}' ID'li konum bölgesine girdiniz!")));
//         break;
//       }
//     }
//   }

//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const earthRadius = 6371000; // metre
//     final dLat = _degToRad(lat2 - lat1);
//     final dLng = _degToRad(lon2 - lon1);
//     final a = sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return earthRadius * c;
//   }

//   double _degToRad(double deg) => deg * (pi / 180);

//   void _startRecording() async {
//     final locationData = await _locationService.getLocation();
//     if (locationData.latitude != null && locationData.longitude != null) {
//       final currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);

//       // Haritayı mevcut konuma taşı
//       _mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));

//       setState(() {
//         _isRecording = true;
//         _currentRouteId = DateTime.now().millisecondsSinceEpoch;
//         _routePoints.clear();
//         _routePoints.add(currentLatLng); // Başlangıç noktasını ekle
//         _currentMarker = Marker(markerId: const MarkerId('current_location'), position: currentLatLng, infoWindow: const InfoWindow(title: "Mevcut Konum"));
//       });

//       print("Kayıt başladı");
//     } else {
//       print("Mevcut konum alınamadı");
//     }
//   }

//   void _stopRecording() {
//     setState(() => _isRecording = false);
//     if (_currentRouteId != null) {
//       final provider = Provider.of<LocationProvider>(context, listen: false);
//       final routeLocations = _routePoints.map((p) => LocationDataModel(latitude: p.latitude, longitude: p.longitude, timestamp: DateTime.now())).toList();
//       provider.saveRoute(_currentRouteId!, routeLocations);
//     }
//     print("Kayıt bitti");
//   }

//   Set<Circle> _buildLocationCircle() {
//     if (_currentLocation == null) return {};
//     return {
//       Circle(
//         circleId: const CircleId("current_circle"),
//         center: _currentLocation!,
//         radius: 20,
//         fillColor: Colors.blue.withOpacity(0.4),
//         strokeColor: Colors.blue,
//         strokeWidth: 2,
//       ),
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LocationProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Harita Ekranı"),
//         actions: [IconButton(icon: const Icon(Icons.history), onPressed: () => Navigator.pushNamed(context, '/history'))],
//       ),
//       body: GoogleMap(
//         initialCameraPosition: const CameraPosition(target: LatLng(37.872669888420376, 32.49263157763532), zoom: 15),
//         onMapCreated: (c) => _mapController = c,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         markers: _currentMarker != null ? {_currentMarker!} : {},
//         polylines: {Polyline(polylineId: const PolylineId("route"), points: _routePoints, width: 4, color: Colors.blue)},
//         circles: {
//           ..._buildLocationCircle(),
//           ...provider.geofences.map(
//             (gf) => Circle(
//               circleId: CircleId('gf_${gf.id}'),
//               center: LatLng(gf.latitude, gf.longitude),
//               radius: gf.radius.toDouble(),
//               fillColor: Colors.green.withOpacity(0.2),
//               strokeColor: Colors.green,
//               strokeWidth: 2,
//             ),
//           ),
//         },
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             backgroundColor: Colors.orange,
//             onPressed: _startRecording,
//             child: const Icon(Icons.location_searching),
//             tooltip: ' Kaydı Başlat',
//           ),
//           const SizedBox(width: 10),
//           FloatingActionButton(backgroundColor: Colors.red, onPressed: _stopRecording, child: const Icon(Icons.stop), tooltip: 'Kaydı Durdur'),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../models/location_model.dart';
import '../providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Location _locationService = Location();
  bool _isRecording = false;
  int? _currentRouteId;
  List<LatLng> _routePoints = [];
  LatLng? _currentLocation;
  Marker? _currentMarker;
  bool _hasNotified = false; // Bildirim durumu
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndSetKonya();
  }

  Future<void> _checkPermissionAndSetKonya() async {
    var permission = await _locationService.hasPermission();
    if (permission != PermissionStatus.granted) {
      permission = await _locationService.requestPermission();
    }

    if (permission == PermissionStatus.granted) {
      // İzin verildiyse sadece Konya koordinatına odaklan (Mevcut konumu otomatik alma)
      setState(() {
        _currentLocation = const LatLng(37.872669888420376, 32.49263157763532);
        _currentMarker = Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: "Konya Başlangıç Konumu"),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konum izni verilmedi!')));
      // İzin yoksa da Konya gösterebiliriz
      setState(() {
        _currentLocation = const LatLng(37.872669888420376, 32.49263157763532);
        _currentMarker = Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: "Konya Başlangıç Konumu"),
        );
      });
    }
  }

  void _startLocationListener() {
    _locationSubscription = _locationService.onLocationChanged.listen((LocationData data) {
      final newPoint = LatLng(data.latitude!, data.longitude!);
      setState(() {
        _currentLocation = newPoint;
        if (_isRecording) {
          _routePoints.add(newPoint);
        }
        _currentMarker = Marker(markerId: const MarkerId('current_location'), position: newPoint, infoWindow: const InfoWindow(title: "Mevcut Konum"));
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(newPoint));
      _checkProximityAndNotify(newPoint);
    });
  }

  void _checkProximityAndNotify(LatLng currentPosition) {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    for (var gf in provider.geofences) {
      final distance = _calculateDistance(currentPosition.latitude, currentPosition.longitude, gf.latitude, gf.longitude);
      if (distance <= gf.radius && !_hasNotified) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("'${gf.id}' ID'li konum bölgesine girdiniz!")));
        _hasNotified = true; // Bildirim gösterildi
        break;
      }
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000; // metre
    final dLat = _degToRad(lat2 - lat1);
    final dLng = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  void _startRecording() async {
    final locationData = await _locationService.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      final currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);

      // Haritayı mevcut konuma taşı
      _mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));

      setState(() {
        _isRecording = true;
        _currentRouteId = DateTime.now().millisecondsSinceEpoch;
        _routePoints.clear();
        _routePoints.add(currentLatLng); // Başlangıç noktasını ekle
        _currentMarker = Marker(markerId: const MarkerId('current_location'), position: currentLatLng, infoWindow: const InfoWindow(title: "Mevcut Konum"));
        _hasNotified = false; // Bildirim sıfırla kayıt başlarken
      });

      // Konum dinleyicisini başlat
      _startLocationListener();

      print("Kayıt başladı");
    } else {
      print("Mevcut konum alınamadı");
    }
  }

  void _stopRecording() {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
      });

      if (_currentRouteId != null) {
        final provider = Provider.of<LocationProvider>(context, listen: false);
        final routeLocations = _routePoints.map((p) => LocationDataModel(latitude: p.latitude, longitude: p.longitude, timestamp: DateTime.now())).toList();
        provider.saveRoute(_currentRouteId!, routeLocations);
      }

      _locationSubscription?.cancel();
      _locationSubscription = null;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt durduruldu.")));

      print("Kayıt bitti");
    }
  }

  Set<Circle> _buildLocationCircle() {
    if (_currentLocation == null) return {};
    return {
      Circle(
        circleId: const CircleId("current_circle"),
        center: _currentLocation!,
        radius: 20,
        fillColor: Colors.blue.withOpacity(0.4),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    };
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Harita Ekranı"),
        actions: [IconButton(icon: const Icon(Icons.history), onPressed: () => Navigator.pushNamed(context, '/history'))],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(37.872669888420376, 32.49263157763532), zoom: 15),
        onMapCreated: (c) {
          _mapController = c;
          // Harita oluşturulduğunda Konya konumuna odaklan
          if (_currentLocation != null) {
            _mapController?.moveCamera(CameraUpdate.newLatLng(_currentLocation!));
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _currentMarker != null ? {_currentMarker!} : {},
        polylines: {Polyline(polylineId: const PolylineId("route"), points: _routePoints, width: 4, color: Colors.blue)},
        circles: {
          ..._buildLocationCircle(),
          ...provider.geofences.map(
            (gf) => Circle(
              circleId: CircleId('gf_${gf.id}'),
              center: LatLng(gf.latitude, gf.longitude),
              radius: gf.radius.toDouble(),
              fillColor: Colors.green.withOpacity(0.2),
              strokeColor: Colors.green,
              strokeWidth: 2,
            ),
          ),
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: _startRecording,
            child: const Icon(Icons.location_searching),
            tooltip: 'Kaydı Başlat',
          ),
          const SizedBox(width: 10),
          FloatingActionButton(backgroundColor: Colors.red, onPressed: _stopRecording, child: const Icon(Icons.stop), tooltip: 'Kaydı Durdur'),
        ],
      ),
    );
  }
}
