import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/widgets/route_box.dart';
import '../provider/google_maps_provider.dart';
import '../provider/local_storage_provider.dart';
import '../provider/state_info.dart';
import 'favorite_button.dart';

class ArrivalAndDepartureTile extends StatefulWidget {
  final ArrivalAndDeparture adInfo;

  const ArrivalAndDepartureTile({
    super.key,
    required this.adInfo,
  });

  @override
  State<ArrivalAndDepartureTile> createState() =>
      _ArrivalAndDepartureTileState();
}

class _ArrivalAndDepartureTileState extends State<ArrivalAndDepartureTile> {
  late LocalStorageProvider localStorage;
  late List<String> favoriteRoutes;

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: false);
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    final iconColor = Theme.of(context).colorScheme.onPrimaryContainer;
    final mapProvider = Provider.of<MapsProvider>(context, listen: false);
    return ListTile(
      title: Row(
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  width: 1.5,
                ),
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  RouteBox(
                    text: widget.adInfo.routeShortName,
                    maxW: 120,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  RouteBox(
                    text: mapProvider.getPredictedArrivalTime(widget.adInfo),
                    maxW: 100,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: "Find my vehicle",
            icon: Icon(
              Icons.directions_bus,
              color: iconColor,
            ),
            onPressed: () async {
              if (widget.adInfo.tripStatus != null) {
                //get all the stops for the current route
                List<LatLng> routeStops =
                    await stateInfo.getRoutePolyline(widget.adInfo.routeId);
                //add those stops to the routeProvider

                routeProvider.setPolyLines(routeStops);

                mapProvider.findBus(stateInfo, widget.adInfo);
              }
            },
          ),
          FavoriteButton(
            routeId: widget.adInfo.routeId,
            routeName: widget.adInfo.routeShortName,
          ),
        ],
      ),
    );
  }

  
}

class MapProvider {
}
