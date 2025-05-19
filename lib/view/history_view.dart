// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../providers/location_provider.dart'; // Doğru yolu yaz
// import '../models/location_model.dart'; // LocationDataModel için gerekli

// class LocationHistoryScreen extends StatefulWidget {
//   final GoogleMapController controller; // controller parametresi burada tanımlanıyor

//   const LocationHistoryScreen({Key? key, required this.controller}) : super(key: key);

//   @override
//   State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
// }
// class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
//   bool _isInitialized = false;
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isInitialized) {
//       Provider.of<LocationProvider>(context, listen: false).init();
//       _isInitialized = true;
//     }
//   }
//   Future<void> _playRoute(int routeId) async {
//     final provider = Provider.of<LocationProvider>(context, listen: false);
//     final routePoints = await provider.fetchRoute(routeId);
//     final GoogleMapController controller = widget.controller; // Nullable kontrolü yapın

//     if (controller != null) {
//       await provider.playRouteAnimation(routeId, controller);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Konum Geçmişi")),
//       body: FutureBuilder<List<int>>(
//         future: Provider.of<LocationProvider>(context, listen: false).fetchRouteIds(), // Future kullanımı
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Hata: ${snapshot.error}"));
//           } else {
//             final routeIds = snapshot.data!; // Artık routeIds bir List<int>
//             if (routeIds.isEmpty) {
//               return const Center(child: Text("Hiç rota kaydı yok."));
//             }

//             return ListView.builder(
//               itemCount: routeIds.length,
//               itemBuilder: (context, index) {
//                 final routeId = routeIds[index];
//                 return ListTile(
//                   leading: const Icon(Icons.location_on),
//                   title: Text("Rota ID: $routeId"),
//                   subtitle: FutureBuilder<List<LocationDataModel>>(
//                     future: Provider.of<LocationProvider>(context, listen: false).fetchRoute(routeId),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator();
//                       } else if (snapshot.hasError) {
//                         return Text("Hata: ${snapshot.error}");
//                       } else {
//                         final routePoints = snapshot.data!;
//                         return Text("Nokta Sayısı: ${routePoints.length}");
//                       }
//                     },
//                   ),
//                   trailing: IconButton(icon: const Icon(Icons.play_arrow), onPressed: () => _playRoute(routeId)),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart'; // Doğru yolu yaz
import '../models/location_model.dart'; // LocationDataModel için gerekli

class LocationHistoryScreen extends StatefulWidget {
  final GoogleMapController controller; // controller parametresi burada tanımlanıyor

  const LocationHistoryScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<LocationProvider>(context, listen: false).init();
      _isInitialized = true;
    }
  }

  Future<void> _playRoute(int routeId) async {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    final routePoints = await provider.fetchRoute(routeId);
    final GoogleMapController controller = widget.controller;

    if (controller != null) {
      await provider.playRouteAnimation(routeId, controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konum Geçmişi")),
      body: Consumer<LocationProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.locationHistory.length,
            itemBuilder: (context, index) {
              final location = provider.locationHistory[index];
              return ListTile(
                title: Text('Lat: ${location.latitude}, Lng: ${location.longitude}'),
                subtitle: Text('Zaman: ${location.timestamp.toString()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () async {
                    // Rota ID'sini al ve oynat
                    await _playRoute(location.id!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
