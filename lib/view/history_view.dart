import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/location_model.dart';
import 'package:flutter_application_1/providers/location_provider.dart';
import 'package:provider/provider.dart';

class PastRoutesScreen extends StatelessWidget {
  const PastRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş Rotalar'), backgroundColor: Colors.green[700]),
      body: Column(
        children: [
          // Tarih seçimi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      locationProvider.fetchRoutesByDate(selectedDate);
                    }
                  },
                  child: const Text('Tarihe Göre Ara'),
                ),
              ],
            ),
          ),
          // Geçmiş rotaları listeleme
          Expanded(
            child: ListView.builder(
              itemCount: locationProvider.pastRoutes.length,
              itemBuilder: (context, index) {
                final route = locationProvider.pastRoutes[index];
                return ListTile(
                  title: Text('Rota ID: ${route['id']}'),
                  subtitle: Text('Tarih: ${route['timestamp']}'),
                  onTap: () {
                    // Tıklayınca provider üzerinden seçili rotayı ayarla
                    locationProvider.showRouteOnMap(LocationDataModel.fromMap(route));

                    // İstersen burada yeni sayfaya da yönlendirebilirsin
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
