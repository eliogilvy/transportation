import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
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
      constraints: const BoxConstraints(minHeight: 50),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 1,
            ),
            top: BorderSide(
              color: Colors.black,
              width: 1,
            )),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    widget.stop.name,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: fire.getRating(widget.stop.stopId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: Colors.black,
                        size: 15,
                      ),
                    );
                  } else if (snapshot.data! == '') {
                    return safetyRating('-');
                  } else {
                    return safetyRating(snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row safetyRating(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        ),
        IconButton(
          onPressed: () async {
            final hasRated = await fire.hasRated(widget.stop.stopId);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      ratingBar(context, hasRated, fire, widget.stop.stopId),
                  backgroundColor: Colors.white,
                ),
              );
            }
          },
          icon: const Icon(Icons.shield_outlined),
          tooltip: 'Rate this stop',
        ),
      ],
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
                    setState(() {});
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ],
            ),
    );
  }
}
