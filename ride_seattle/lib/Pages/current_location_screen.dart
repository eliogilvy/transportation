import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/marker_sheet.dart';

import '../classes/stop.dart';
import '../provider/state_info.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  GoogleMapController? googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(47.6092, -122.3178), zoom: 16);
  Map<String, Marker> markers = {};

  set currentCenter(position) => currentCenter = position;

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    return Scaffold(
      body: Builder(
        builder: (context) => GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: stateInfo.markers,
          circles: stateInfo.circles,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          onTap: (argument) {
            stateInfo.showMarkerInfo = false;
            Navigator.of(context).maybePop();
          },
          onCameraIdle: () {
            updateView(stateInfo);
            if (stateInfo.showMarkerInfo) {
              Scaffold.of(context).showBottomSheet(
                (BuildContext context) {
                  return const MarkerSheet();
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = stateInfo.position;
          googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 16,
              ),
            ),
          );
          stateInfo.addMarker(
              'currentLocation', LatLng(position.latitude, position.longitude));
        },
        child: const Icon(Icons.location_history),
      ),
    );
  }

  Future<LatLng> getTopOfScreen(GoogleMapController controller) {
    return controller.getVisibleRegion().then(((value) {
      return value.northeast;
    }));
  }

  Future<LatLng> getBottomOfScreen(GoogleMapController controller) {
    return controller.getVisibleRegion().then(((value) {
      return value.southwest;
    }));
  }

  Future<LatLng> getCurrentCenter(GoogleMapController controller) {
    return controller.getVisibleRegion().then((value) {
      return LatLng((value.southwest.latitude + value.northeast.latitude) / 2,
          (value.southwest.longitude + value.northeast.longitude) / 2);
    });
  }

  Future<void> updateView(StateInfo stateInfo) async {
    final LatLng center = await getCurrentCenter(googleMapController!);
    final LatLng currentCenter = LatLng(center.latitude, center.longitude);
    await stateInfo.getPosition();
    await stateInfo.setRadius(
        currentCenter,
        await getTopOfScreen(googleMapController!),
        await getBottomOfScreen(googleMapController!));
    stateInfo.getStopsForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.addCircle(currentCenter, 'searchRadius');
  }
}
