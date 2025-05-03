import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomeScreen();
  }

  // Ana sayfaya geçiş için süre belirleyelim
  void _navigateToHomeScreen() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Ana ekranınızın widget'ını buraya yerleştirin
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Splash ekranı için arka plan rengi
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo veya herhangi bir öğe
            Icon(Icons.home, size: 100, color: Colors.white),
            SizedBox(height: 20),
            // Uygulama adı veya logo metni
            Text('Uygulama Adı', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
