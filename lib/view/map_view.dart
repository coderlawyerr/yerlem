import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  List<LatLng> _routePoints = [];
  late Location _locationService;
  Marker? _currentLocationMarker;
  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    _locationService = Location();
    Provider.of<LocationProvider>(context, listen: false).initDatabase();
    _initWebSocket();
    _listenLocation();
  }

  void _initWebSocket() {
    // Buraya kendi WebSocket sunucu adresini yazabilirsin
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.org'), // Test server için
      // Örneğin kendi sunucun olursa ws://ip_adresi:port
    );
  }

  void _listenLocation() async {
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationService.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        LatLng newPoint = LatLng(locationData.latitude!, locationData.longitude!);

        setState(() {
          _routePoints.add(newPoint);
          _currentLocationMarker = Marker(
            markerId: const MarkerId('current_location'),
            position: newPoint,
          );
        });

        Provider.of<LocationProvider>(context, listen: false).insertLocation(newPoint);

        _mapController?.animateCamera(CameraUpdate.newLatLng(newPoint));

        // Konumu WebSocket ile gönder
        _sendLocationOverWebSocket(newPoint);
      }
    });
  }

  void _sendLocationOverWebSocket(LatLng point) {
    if (_channel != null) {
      final locationData = {
        'latitude': point.latitude,
        'longitude': point.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      };
      _channel!.sink.add(jsonEncode(locationData));
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş Rotalar ve Canlı Konum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          Set<Polyline> polylines = {
            Polyline(
              polylineId: const PolylineId('live_route'),
              points: _routePoints,
              color: Colors.blue,
              width: 5,
            ),
          };

          Set<Marker> markers = {};
          if (_currentLocationMarker != null) {
            markers.add(_currentLocationMarker!);
          }

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.872669888420376, 32.49263157763532),
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: markers,
            polylines: polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      Provider.of<LocationProvider>(context, listen: false).fetchRoutesByDate(picked);
      setState(() {
        _routePoints.clear();
      });
    }
  }
}
