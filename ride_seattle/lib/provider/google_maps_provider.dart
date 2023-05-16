import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/provider/state_info.dart';

class MapsProvider with ChangeNotifier {
  MapsProvider({this.controller});
  GoogleMapController? controller;

  void onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  void findBus(StateInfo stateInfo, ArrivalAndDeparture adInfo) async {
    stateInfo.removeMarker(stateInfo.lastVehicle);
    stateInfo.vehicleStatus = adInfo.tripStatus!;
    stateInfo.lastVehicle = adInfo.tripStatus!.activeTripId;
    stateInfo.addMarker(adInfo.tripStatus!.activeTripId, adInfo.routeShortName,
        adInfo.tripStatus!.position, stateInfo.getVehicleInfo,
        iconFilepath: 'assets/images/bus.png');
    controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: adInfo.tripStatus!.position,
          zoom: 16,
        ),
      ),
    );
  }

  String getPredictedArrivalTime(ArrivalAndDeparture adInfo) {
    int prediction;
    if (adInfo.predictedArrivalTime == 0) {
      prediction = adInfo.scheduledArrivalTime;
    } else {
      prediction = adInfo.predictedArrivalTime;
    }
    int now = DateTime.now().millisecondsSinceEpoch;

    int difference = prediction - now;
    int differenceInMinutes = difference ~/ 60000;
    if (differenceInMinutes == 0) {
      return "NOW";
    } else if (differenceInMinutes < 0) {
      return "Departed";
    }
    return "${differenceInMinutes.toString()} min";
  }

  void go(LatLng loc) {
    controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: loc,
          zoom: 16,
        ),
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
    final LatLng center = await getCurrentCenter(controller!);
    final LatLng currentCenter = LatLng(center.latitude, center.longitude);
    await stateInfo.getPosition();
    stateInfo.setRadius(
        currentCenter, await getTopOfScreen(controller!), await getBottomOfScreen(controller!));
    stateInfo.getStopsForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.getRoutesForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.addCircle(currentCenter, 'searchRadius');
  }
}
