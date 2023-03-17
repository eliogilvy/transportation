import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/auth.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.routeId,
    required this.routeName,
  });
  final String routeId;
  final String routeName;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    Stream<QuerySnapshot> stream = fire.routeStream(widget.routeId);

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.star_border,
            ),
          );
        } else {
          return snapshot.data!.docs.isEmpty
              ? IconButton(
                  tooltip: "Add to favorites",
                  icon: const Icon(
                    Icons.star_border,
                  ),
                  onPressed: () async {
                    // storage.addRoute(widget.routeId);
                    fire.uploadingData(widget.routeId, widget.routeName);
                  },
                )
              : IconButton(
                  tooltip: "Remove from favorites",
                  icon: const Icon(
                    Icons.star,
                  ),
                  onPressed: () async {
                    fire.removeData(widget.routeId);
                  },
                );
        }
      },
    );
  }
}
