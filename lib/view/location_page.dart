import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/location_model.dart';
import '../providers/location_provider.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _radiusController = TextEditingController();

  LatLng? _selectedPosition;
  int _circleIdCounter = 1;

  Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;

      final markerId = MarkerId('marker_${_markers.length + 1}');
      final marker = Marker(markerId: markerId, position: position);

      _markers.add(marker); // Yeni marker'ı var olanlara ekle
    });
  }

  void _addCircle(LatLng center, double radius) {
    final String circleIdVal = 'circle_$_circleIdCounter';
    _circleIdCounter++;

    final Circle circle = Circle(
      circleId: CircleId(circleIdVal),
      center: center,
      radius: radius,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );

    setState(() {
      _circles.add(circle); // Yeni çemberi var olanlara ekle
    });
  }

  void _clearInputFields() {
    _radiusController.clear();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konum Ekle')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: const CameraPosition(
                target: LatLng(39.925533, 32.866287), // Ankara
                zoom: 12,
              ),
              onTap: _onMapTap,
              markers: _markers,
              circles: _circles,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _radiusController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Yarıçap (metre)", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Konumu Kaydet'),
                    onPressed: () async {
                      if (_selectedPosition == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen haritada bir konum seçin!")));
                        return;
                      }

                      if (_radiusController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen bir yarıçap girin!")));
                        return;
                      }

                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Kaydet"),
                              content: const Text("Bu konumu ve yarıçapı kaydetmek istiyor musunuz?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("İptal")),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Evet")),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        final radius = double.tryParse(_radiusController.text);
                        if (radius == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Geçerli bir yarıçap girin!")));
                          return;
                        }

                        final geofence = GeofenceModel(latitude: _selectedPosition!.latitude, longitude: _selectedPosition!.longitude, radius: radius.toInt());

                        await Provider.of<LocationProvider>(context, listen: false).insertGeofence(geofence);
                        _addCircle(_selectedPosition!, radius);
                        _clearInputFields();

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Konum başarıyla kaydedildi.")));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
