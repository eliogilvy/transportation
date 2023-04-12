import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'package:ride_seattle/widgets/loading.dart';

import '../classes/stop.dart';
import '../provider/state_info.dart';

class RouteName extends StatefulWidget {
  final Stop stop;
  const RouteName({super.key, required this.stop});

  @override
  State<RouteName> createState() => _RouteNameState();
}

class _RouteNameState extends State<RouteName> {
  late FireProvider fire = Provider.of<FireProvider>(context, listen: false);
  late StateInfo stateInfo = Provider.of<StateInfo>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                  widget.stop.name,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'route',
                  ),
                ),
              ),
            ),
            FutureBuilder(
                future: fire.getRating(widget.stop.stopId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LoadingWidget();
                  } else if (snapshot.data! == '') {
                    return Text(
                      '-',
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    );
                  } else {
                    return Text(
                      snapshot.data!,
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    );
                  }
                }),
            IconButton(
              onPressed: () async {
                final hasRated = await fire.hasRated(widget.stop.stopId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: ratingBar(
                          context, hasRated, fire, widget.stop.stopId),
                      backgroundColor: Colors.white,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.shield_outlined),
              tooltip: 'Rate this stop',
            )
          ],
        ),
      ),
    );
  }

  Widget ratingBar(
      BuildContext context, bool hasRated, FireProvider fire, String stopId) {
    return Center(
      child: hasRated
          ? Text(
              'You have rated the safety of this stop in the past week',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            )
          : Column(
              children: [
                Text(
                  'How safe do you feel at this stop?',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                RatingBar.builder(
                    itemBuilder: (context, _) => const Icon(Icons.star),
                    onRatingUpdate: (rating) {
                      fire.addRating(stopId, rating);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }),
              ],
            ),
    );
  }
}
