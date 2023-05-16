import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/google_maps_provider.dart';
import 'package:ride_seattle/provider/state_info.dart';
import 'package:ride_seattle/widgets/nav_bar.dart';

import '../provider/nav_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context, listen: true);
    final mapProvider = Provider.of<MapsProvider>(context, listen: true);
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    return Scaffold(
      body: navProvider.destinations[navProvider.currentIndex],
      bottomNavigationBar: const NavBar(),
      floatingActionButton: navProvider.isMaps
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                Position position = stateInfo.position;
                mapProvider.go(LatLng(position.latitude, position.longitude));
              },
              child: Icon(
                Icons.gps_fixed,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
    );
  }
}
