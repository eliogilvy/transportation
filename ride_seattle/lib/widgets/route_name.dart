import 'package:flutter/material.dart';

import '../classes/stop.dart';

class RouteName extends StatelessWidget {
  final Stop stop;
  const RouteName({super.key, required this.stop});

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
                  stop.name,
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
            IconButton(
              onPressed: () {
                print(stop.routeIds);
              },
              icon: const Icon(Icons.nfc),
              tooltip: 'Add your stop',
            )
          ],
        ),
      ),
    );
  }
}
