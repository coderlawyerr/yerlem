import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/view/history_view.dart';
import 'package:flutter_application_1/view/location_page.dart';
import 'package:flutter_application_1/view/map_view.dart';
import 'package:flutter_application_1/view/settings_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 1;
  late PageController pageController;
  GoogleMapController? _mapController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    /// [AnnotatedRegion<SystemUiOverlayStyle>] only for android black navigation bar. 3 button navigation control (legacy)
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(systemNavigationBarColor: navigationBarColor, systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            MapScreen(),
            SettingsView(),
            _mapController == null ? Center(child: Text("")) : LocationHistoryScreen(controller: _mapController!),
            AddLocationScreen(),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: navigationBarColor,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex, duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(filledIcon: Icons.abc, outlinedIcon: Icons.abc_outlined),
            // History sekmesi için ikon
            BarItem(filledIcon: Icons.history_rounded, outlinedIcon: Icons.history_outlined),
            // Map sekmesi için ikon
            BarItem(filledIcon: Icons.map_rounded, outlinedIcon: Icons.map_outlined),
            // Settings sekmesi için ikon
            BarItem(filledIcon: Icons.settings_rounded, outlinedIcon: Icons.settings_outlined),
          ],
        ),
      ),
    );
  }
}
