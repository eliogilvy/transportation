import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../classes/itinerary.dart';
import '../provider/route_provider.dart';
import '../provider/state_info.dart';

class ItineraryList extends StatelessWidget {
  const ItineraryList({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context);
    final routeProvider = Provider.of<RouteProvider>(context);
    final plan = stateInfo.plan!;
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        controller: controller,
        itemBuilder: (context, index) {
          final itinerary = plan.itineraries[index];
          return ListTile(
              title: showLegs(itinerary, context),
              trailing: Text(
                '${getTime(itinerary.endTime, itinerary.startTime)} min',
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
              onTap: () {
                routeProvider.clearPolylines();
                int id = 0;
                List<LatLng> total = [];
                List<LatLng> points = [];
                List<PointLatLng> coords = [];

                for (var leg in itinerary.legs) {
                  points = [];
                  coords =
                      PolylinePoints().decodePolyline(leg.legGeometry.points);
                  for (var coord in coords) {
                    points.add(LatLng(coord.latitude, coord.longitude));
                    total.add(LatLng(coord.latitude, coord.longitude));
                  }
                  if (leg.mode == 'WALK') {
                    routeProvider.setPolyLines(
                      points,
                      color: Colors.blue,
                      id: id.toString(),
                    );
                  } else {
                    routeProvider.setPolyLines(points,
                        color: Colors.orange, id: id.toString());
                  }
                  id++;
                }
                LatLngBounds bounds = LatLngBounds(
                  southwest: total.reduce((value, element) => LatLng(
                        value.latitude < element.latitude
                            ? value.latitude
                            : element.latitude,
                        value.longitude < element.longitude
                            ? value.longitude
                            : element.longitude,
                      )),
                  northeast: total.reduce((value, element) => LatLng(
                        value.latitude > element.latitude
                            ? value.latitude
                            : element.latitude,
                        value.longitude > element.longitude
                            ? value.longitude
                            : element.longitude,
                      )),
                );
                stateInfo.mapController
                    .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
              });
        },
        itemCount: stateInfo.plan!.itineraries.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
          );
        },
      ),
    );
  }

  Row showLegs(Itinerary itinerary, BuildContext context) {
    List<Widget> widgets = [];
    for (var leg in itinerary.legs) {
      widgets.add(Column(
        children: [
          leg.mode != 'WALK'
              ? const Icon(
                  Icons.directions_bus,
                )
              : const Icon(
                  Icons.directions_walk,
                ),
          Text(
            getTime(leg.endTime, leg.startTime),
            style: Theme.of(context).primaryTextTheme.bodySmall,
          ),
        ],
      ));
      widgets.add(const Icon(Icons.arrow_forward));
    }
    widgets.removeLast();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }

  String getTime(int arrival, int departure) {
    int difference = arrival - departure;
    difference ~/= 60000;
    return difference.toString();
  }
}
