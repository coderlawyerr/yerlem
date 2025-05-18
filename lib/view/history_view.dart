// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../providers/location_provider.dart';
// import '../models/location_model.dart';

// class LocationHistoryScreen extends StatelessWidget {
//   final GoogleMapController? mapController;

//   LocationHistoryScreen({required this.mapController}); // Yapıcıda kontrolcüyü alıyoruz

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Konum Geçmişi')),
//       body: Consumer<LocationProvider>(
//         builder: (context, locationProvider, child) {
//           // Rota ID'lerini fetch ediyoruz
//           return FutureBuilder<List<int>>(
//             future: locationProvider.fetchRouteIds(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('Geçmiş rota bulunamadı.'));
//               }

//               final routeIds = snapshot.data!;

//               return ListView.builder(
//                 itemCount: routeIds.length,
//                 itemBuilder: (context, index) {
//                   final routeId = routeIds[index];
//                   return FutureBuilder<List<LocationDataModel>>(
//                     future: locationProvider.fetchRoute(routeId),
//                     builder: (context, routeSnapshot) {
//                       if (routeSnapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (!routeSnapshot.hasData || routeSnapshot.data!.isEmpty) {
//                         return const ListTile(title: Text('Rota bulunamadı.'));
//                       }

//                       final routePoints = routeSnapshot.data!;
//                       final startTime = routePoints.first.timestamp;
//                       final endTime = routePoints.last.timestamp;

//                       return ListTile(
//                         title: Text('Rota ID: $routeId'),
//                         subtitle: Text('Başlangıç: $startTime, Bitiş: $endTime'),
//                         trailing: ElevatedButton(
//                           onPressed: () async {
//                             // Rota animasyonunu başlat
//                             await locationProvider.playRouteOnMap(
//                               mapController!, // Harita kontrolcüsünü burada geçiyoruz
//                               routePoints.map((p) => LatLng(p.latitude, p.longitude)).toList(),
//                             );
//                           },
//                           child: const Text('Oynat'),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../providers/location_provider.dart';
// import '../models/location_model.dart';

// class LocationHistoryScreen extends StatelessWidget {
//   final GoogleMapController? mapController;

//   LocationHistoryScreen({required this.mapController});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Konum Geçmişi')),
//       body: Consumer<LocationProvider>(
//         builder: (context, locationProvider, child) {
//           return FutureBuilder<List<int>>(
//             future: locationProvider.fetchRouteIds(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('Geçmiş rota bulunamadı.'));
//               }

//               final routeIds = snapshot.data!;

//               return ListView.builder(
//                 itemCount: routeIds.length,
//                 itemBuilder: (context, index) {
//                   final routeId = routeIds[index];

//                   return FutureBuilder<List<LocationDataModel>>(
//                     future: locationProvider.fetchRoute(routeId),
//                     builder: (context, routeSnapshot) {
//                       if (routeSnapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (!routeSnapshot.hasData || routeSnapshot.data!.isEmpty) {
//                         return const ListTile(title: Text('Rota bulunamadı.'));
//                       }

//                       final routePoints = routeSnapshot.data!;
//                       final startTime = routePoints.first.timestamp;
//                       final endTime = routePoints.last.timestamp;

//                       // Bildirim gönderilen noktalar
//                       final notifiedPoints = routePoints.where((p) => p.notified == true).toList();

//                       return Card(
//                         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         elevation: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Rota ID: $routeId', style: TextStyle(fontWeight: FontWeight.bold)),
//                               const SizedBox(height: 4),
//                               Text('Başlangıç: $startTime'),
//                               Text('Bitiş: $endTime'),
//                               const SizedBox(height: 6),

//                               ExpansionTile(
//                                 title: const Text('Geçilen Konumlar'),
//                                 children:
//                                     routePoints.map((point) {
//                                       return ListTile(
//                                         title: Text('Lat: ${point.latitude}, Lng: ${point.longitude}'),
//                                         subtitle: Text('Zaman: ${point.timestamp}'),
//                                       );
//                                     }).toList(),
//                               ),

//                               if (notifiedPoints.isNotEmpty)
//                                 ExpansionTile(
//                                   title: const Text('Bildirim Gönderilen Noktalar'),
//                                   children:
//                                       notifiedPoints.map((point) {
//                                         return ListTile(title: Text('${point.geofenceName ?? 'Bilinmeyen Alan'}'), subtitle: Text('Zaman: ${point.timestamp}'));
//                                       }).toList(),
//                                 ),

//                               const SizedBox(height: 8),

//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: ElevatedButton.icon(
//                                   onPressed: () async {
//                                     await locationProvider.playRouteOnMap(mapController!, routePoints.map((p) => LatLng(p.latitude, p.longitude)).toList());
//                                   },
//                                   icon: const Icon(Icons.play_arrow),
//                                   label: const Text('Oynat'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../models/location_model.dart';

class LocationHistoryScreen extends StatelessWidget {
  final GoogleMapController? mapController;

  LocationHistoryScreen({required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konum Geçmişi')),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return FutureBuilder<List<int>>(
            future: locationProvider.fetchRouteIds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Geçmiş rota bulunamadı.'));
              }

              final routeIds = snapshot.data!;

              return ListView.builder(
                itemCount: routeIds.length,
                itemBuilder: (context, index) {
                  final routeId = routeIds[index];

                  return FutureBuilder<List<LocationDataModel>>(
                    future: locationProvider.fetchRoute(routeId),
                    builder: (context, routeSnapshot) {
                      if (routeSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!routeSnapshot.hasData || routeSnapshot.data!.isEmpty) {
                        return const ListTile(title: Text('Rota bulunamadı.'));
                      }

                      final routePoints = routeSnapshot.data!;
                      final startTime = routePoints.first.timestamp;
                      final endTime = routePoints.last.timestamp;
                      final notifiedPoints = routePoints.where((p) => p.notified == true).toList();

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.directions),
                              title: Text('Rota ID: $routeId'),
                              subtitle: Text(
                                'Başlangıç: ${startTime.toLocal().toString().substring(0, 19)}\n'
                                'Bitiş: ${endTime.toLocal().toString().substring(0, 19)}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {
                                  final latLngRoute = routePoints.map((p) => LatLng(p.latitude, p.longitude)).toList();
                                  locationProvider.playRouteOnMap(mapController!, latLngRoute);
                                },
                              ),
                            ),

                            if (routePoints.isNotEmpty)
                              ExpansionTile(
                                title: const Text('Geçilen Konumlar'),
                                children:
                                    routePoints.map((point) {
                                      return ListTile(
                                        title: Text('Lat: ${point.latitude}, Lng: ${point.longitude}'),
                                        subtitle: Text('Zaman: ${point.timestamp}'),
                                      );
                                    }).toList(),
                              ),

                            if (notifiedPoints.isNotEmpty)
                              if (notifiedPoints.isNotEmpty)
                                ExpansionTile(
                                  title: const Text('Bildirim Gönderilen Noktalar'),
                                  children:
                                      notifiedPoints.map((point) {
                                        return ListTile(
                                          title: Text(point.geofenceName ?? 'Bilinmeyen Alan'),
                                          subtitle: Text('Zaman: ${point.timestamp.toLocal().toString().substring(0, 19)}'),
                                        );
                                      }).toList(),
                                ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
