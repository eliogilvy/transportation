import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/marker_sheet.dart';
import 'package:ride_seattle/widgets/search_box.dart';
import 'package:ride_seattle/widgets/trip_sheet.dart';
import '../provider/route_provider.dart';
import '../provider/state_info.dart';
import '../widgets/nav_drawer.dart';
import 'package:go_router/go_router.dart';

import '../widgets/route_list.dart';
import '../widgets/vehicle_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late String _mapStyle;
  bool _backButton = false;

  Completer<GoogleMapController> googleMapController = Completer();
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(47.6219, -122.3517), zoom: 16);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool search = false;

  @override
  initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then(
      (string) {
        _mapStyle = string;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    final routeProvider = Provider.of<RouteProvider>(context, listen: true);
    final iconColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Ride Seattle',
          style: Theme.of(context).primaryTextTheme.displaySmall,
        ),
        leading: _scaffoldKey.currentState != null && _backButton
            ? IconButton(
                key: const Key('drawer_closed'),
                onPressed: () {
                  setState(() {
                    _scaffoldKey.currentState!.openEndDrawer();
                  });
                },
                icon: Icon(Icons.arrow_back, color: iconColor))
            : IconButton(
                key: const Key('drawer_open'),
                icon: Icon(
                  Icons.dehaze,
                  color: iconColor,
                ),
                onPressed: () {
                  setState(() {
                    _scaffoldKey.currentState!.openDrawer();
                  });
                },
              ),
        actions: [
          // IconButton(
          //     onPressed: () => setState(
          //           () {
          //             search = true;
          //           },
          //         ),
          //     icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Find a route",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    stateInfo.routeFilter = [];
                                    routeProvider.clearPolylines();
                                    if (context.canPop()) context.pop();
                                  },
                                  icon: const Icon(Icons.refresh_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const RouteList(),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        drawer: const NavDrawer(),
        onDrawerChanged: (isOpened) {
          if (mounted) {
            setState(() {
              _backButton = !_backButton;
            });
          }
        },
        body: Column(
          children: [
            // search
            //     ? Container(
            //         padding: const EdgeInsets.all(8.0),
            //         child: SearchBox(callback: () {
            //           if (mounted) {
            //             setState(() {
            //               search = false;
            //             });
            //           }
            //         }),
            //       )
            //     : Container(),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GoogleMap(
                    key: const ValueKey("googleMap"),
                    rotateGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    initialCameraPosition: initialCameraPosition,
                    markers: stateInfo.markers,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      if (mounted) {
                        googleMapController.complete(controller);
                        controller.setMapStyle(_mapStyle);
                        stateInfo.mapController = controller;
                      }
                    },
                    onTap: (argument) {
                      if (mounted) {
                        stateInfo.showVehicleInfo = false;
                        stateInfo.showMarkerInfo = false;
                        stateInfo.showTripInfo = false;
                        stateInfo.removeMarker('current');
                        routeProvider.clearPolylines();
                        stateInfo.removeMarker(stateInfo.lastVehicle);
                        FocusScope.of(context).unfocus();
                      }
                    },
                    onCameraIdle: () {
                      updateView(stateInfo);
                    },
                    polylines: routeProvider.routePolyLine,
                  ),
                  stateInfo.showMarkerInfo
                      ? MarkerSheet(controller: googleMapController)
                      : stateInfo.showVehicleInfo
                          ? const VehicleSheet()
                          : stateInfo.showTripInfo
                              ? TripSheet(
                                  callback: () {
                                    if (mounted) {
                                      setState(() {
                                        stateInfo.showTripInfo = false;
                                      });
                                    }
                                  },
                                )
                              : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            GoogleMapController c = await googleMapController.future;
            Position position = stateInfo.position;
            c.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 16,
                ),
              ),
            );
          },
          child: const Icon(Icons.gps_fixed),
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
    GoogleMapController c = await googleMapController.future;
    final LatLng center = await getCurrentCenter(c);
    final LatLng currentCenter = LatLng(center.latitude, center.longitude);
    await stateInfo.getPosition();
    stateInfo.setRadius(
        currentCenter, await getTopOfScreen(c), await getBottomOfScreen(c));
    stateInfo.getStopsForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.getRoutesForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.addCircle(currentCenter, 'searchRadius');
  }
}
