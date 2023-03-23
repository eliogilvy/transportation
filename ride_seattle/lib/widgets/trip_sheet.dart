import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/helpers/otp.dart';

import '../provider/state_info.dart';
import 'itinerary_list.dart';
import 'loading.dart';

class TripSheet extends StatefulWidget {
  const TripSheet({super.key, required this.callback});
  final Function callback;

  @override
  State<TripSheet> createState() => _TripSheetState();
}

class _TripSheetState extends State<TripSheet> {
  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context);
    return DraggableScrollableSheet(
      builder: (context, controller) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: stateInfo.plan != null
              ? Column(
                  children: [
                    FutureBuilder(
                        future: getAddress(
                            stateInfo.plan!.to.lat, stateInfo.plan!.to.lon),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Your trip to ${snapshot.data}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium),
                                  IconButton(
                                      onPressed: () {
                                        widget.callback();
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                            );
                          } else {
                            return const LoadingWidget();
                          }
                        }),
                    ItineraryList(
                      controller: controller,
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

  Future<String> getAddress(double lat, double lon) async {
    final otp = OtpHelper();

    return await otp.getAddress(lat, lon);
  }
}
