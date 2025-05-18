import 'package:flutter/material.dart';
import 'package:flutter_application_1/onboarding/splashscreen.dart';
import 'package:flutter_application_1/providers/location_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'ı başlat
  final locationProvider = LocationProvider();
  await locationProvider.init(); // Veritabanını başlat
  runApp(ChangeNotifierProvider<LocationProvider>.value(value: locationProvider, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Canlı Konum Takibi',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: SplashScreen(), // Ana ekranımız MapScreen
    );
  }
}
