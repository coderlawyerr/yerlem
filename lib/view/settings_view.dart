import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Ayarlar',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Hakkında'),
            onTap: () {
              // Hakkında sayfasına yönlendirme
            },
          ),
          ListTile(
            title: const Text('Gizlilik Politikası'),
            onTap: () {
              // Gizlilik politikası sayfasına yönlendirme
            },
          ),
        ],
      ),
    );
  }
}