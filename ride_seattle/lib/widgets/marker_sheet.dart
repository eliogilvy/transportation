import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/arrival_and_departure_list.dart';
import 'package:ride_seattle/widgets/route_name.dart';

import '../provider/state_info.dart';
import 'loading.dart';

class MarkerSheet extends StatelessWidget {
  const MarkerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: stateInfo.currentStopInfo != null &&
                  stateInfo
                      .currentStopInfo!.arrivalAndDeparture.values.isNotEmpty
              ? Column(
                  children: [
                    RouteName(stop: stateInfo.currentStopInfo!),
                    ArrivalAndDepartureList(
                      scrollController: scrollController,
                    ),
                  ],
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(child: LoadingWidget()),
                ),
        );
      },
      controller: DraggableScrollableController(),
      expand: false,
      initialChildSize: 0.2,
      maxChildSize: 0.5,
      minChildSize: 0.2,
    );
  }
}
