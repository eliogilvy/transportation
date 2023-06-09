import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';

import '../provider/route_provider.dart';
import '../provider/state_info.dart';

class RouteTile extends StatefulWidget {
  RouteTile({super.key, required this.routeName, required this.routeId});
  final String routeName;
  final String routeId;
  bool longpress = false;
  @override
  State<RouteTile> createState() => _RouteTileState();
}

class _RouteTileState extends State<RouteTile> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      loading = false;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    final stateInfo = Provider.of<StateInfo>(context);
    final routeProvider = Provider.of<RouteProvider>(context);
    final iconColor = Theme.of(context).colorScheme.onInverseSurface;
    final deleteColor = Theme.of(context).colorScheme.error;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).colorScheme.inversePrimary,
      elevation: 2,
      child: Stack(
        children: [
          ListTile(
            title: Center(
              child: Text(
                widget.routeName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            onTap: () async {
              setState(() {
                loading = true;
              });

              List<LatLng> routeStops =
                  await stateInfo.getRoutePolyline(widget.routeId);
              stateInfo.routeFilter = [];
              stateInfo.routeFilter.add(widget.routeId);
              stateInfo.updateStops();

              routeProvider.setPolyLines(routeStops);
              if (mounted) {
                context.go('/');
              }
            },
            onLongPress: () => setState(() {
              widget.longpress = true;
            }),
          ),
          widget.longpress
              ? Positioned(
                  left: 0,
                  child: IconButton(
                    onPressed: () => setState(() {
                      widget.longpress = false;
                    }),
                    icon: Icon(
                      Icons.close,
                      color: iconColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.longpress
              ? Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      fire.removeRoute(widget.routeId);
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      color: deleteColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          loading
              ? Center(child: LoadingAnimationWidget.inkDrop(color: Colors.white, size: 60))
              : Container(),
        ],
      ),
    );
  }
}
