import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/auth.dart';
import '../classes/stop.dart';

class RouteProvider with ChangeNotifier {

  List<Stop> stopsForRoute = [];
  Set<Polyline> routePolyLine = {};

  void addItem(Stop stop) {
    stopsForRoute.add(stop);
    notifyListeners();
  }

  void assignStops(List<Stop> stops) {
    stopsForRoute = stops;
    notifyListeners();
  }

  List<Stop> getStops() {
    return stopsForRoute;
  }

  void setPolyLines(List<LatLng> routeStops, {Color? color, String? id}) {
    routePolyLine.add(
      Polyline(
          polylineId: PolylineId(id ?? 'current_route'),
          points: routeStops,
          color: color ?? Colors.orange,
          width: 4,
          startCap: Cap.squareCap),
    );

    notifyListeners();
  }

  void clearPolylines() {
    routePolyLine.clear();
    notifyListeners();
  }
}
