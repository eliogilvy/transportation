import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/helpers/otp.dart';
import 'package:ride_seattle/provider/route_provider.dart';

import '../classes/itinerary.dart';
import '../classes/place.dart';
import '../classes/plan.dart';
import '../provider/state_info.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key, required this.callback});
  final Function callback;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController controller = TextEditingController();
  List<Place> places = [];

  @override
  Widget build(BuildContext context) {
    final otp = OtpHelper();
    final stateInfo = Provider.of<StateInfo>(context);
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            if (value.isNotEmpty) {
              otp.getAddresses(value).then((result) {
                setState(() {
                  places = result;
                });
              });
            }
          },
          controller: controller,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: () {
                widget.callback();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'Where to?',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: 'route',
              fontSize: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        if (places.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .3),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: places.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    places[index].displayName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    if (mounted) {
                      String start =
                          '${stateInfo.position.latitude}, ${stateInfo.position.longitude}';
                      String finish =
                          '${places[index].lat}, ${places[index].lon}';
                      stateInfo.plan = await otp.getTripPlan(start, finish);
                      stateInfo.showMarkerInfo = false;
                      stateInfo.showVehicleInfo = false;
                      stateInfo.showTripInfo = true;
                      stateInfo.mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(stateInfo.position.latitude,
                                stateInfo.position.longitude),
                            zoom: 16,
                          ),
                        ),
                      );
                      setState(() {
                        places = [];
                      });
                      if (context.mounted) FocusScope.of(context).unfocus();
                    }
                  },
                );
              }),
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
                );
              },
            ),
          )
      ],
    );
  }
}
