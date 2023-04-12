import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_seattle/classes/auth.dart';
import 'package:ride_seattle/classes/fav_route.dart';
import 'package:collection/collection.dart';

class FireProvider with ChangeNotifier {
  FireProvider({required this.fb, required this.auth}) {
    user = auth.currentUser;
    users = fb.collection('users');
    ratings = fb.collection('ratings');
  }

  Auth auth;

  FirebaseFirestore fb;

  late CollectionReference<Map<String, dynamic>> users;
  late CollectionReference<Map<String, dynamic>> ratings;
  User? user;

  Stream<QuerySnapshot> routeStream(String routeId) {
    return users
        .doc(user?.uid) // add null check here
        .collection('routes')
        .where('route_id', isEqualTo: routeId)
        .snapshots();
  }

  Stream<List<FavoriteRoute>> get routeList {
    if (user != null) {
      return users
          .doc(user!.uid)
          .collection('routes')
          .orderBy('route_name')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FavoriteRoute.fromJson(doc.data()))
              .toList());
    } else {
      return Stream.value([]);
    }
  }

  Future<void> removeRoute(String routeId) async {
    final routeToDelete = await users
        .doc(user!.uid)
        .collection('routes')
        .where('route_id', isEqualTo: routeId)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs[0].reference;
    });

    final docTask =
        users.doc(user!.uid).collection('routes').doc(routeToDelete.id);
    await docTask.delete();
  }

  Future<void> addRoute(String routeId, String routeName) async {
    users
        .doc(user!.uid)
        .collection('routes')
        .add({'route_id': routeId, 'route_name': routeName});
  }

  Future<void> addRating(String stopId, double rating) async {
    ratings.doc(stopId).set({
      'ratings': FieldValue.arrayUnion([rating])
    }, SetOptions(merge: true));

    users.doc(user!.uid).collection('stop_ratings').add({
      'stop_id': stopId,
      'last_rating': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<String> getRating(String stopId) async {
    final list = await ratings.doc(stopId).get();
    String formatted = '';
    if (list.data() != null) {
      List ratingsList = list.data()!['ratings'];
      List<double> newList = ratingsList.cast<double>();

      double average = newList.average;

      if (average == average.toInt().toDouble()) {
        // number is a whole number, display it as an integer
        formatted = average.toInt().toString();
      } else {
        // number has a fractional part, display it with one decimal place
        formatted = average.toStringAsFixed(1);
      }
    }

    return formatted;
  }

  Future<bool> hasRated(String stopId) async {
    final ratingsRef = users.doc(user!.uid).collection('stop_ratings');

    // Get the latest rating for the stop
    final query =
        await ratingsRef.where('stop_id', isEqualTo: stopId).limit(1).get();

    // If there are no ratings for the stop, return false
    if (query.docs.isEmpty) {
      return false;
    }

    // Check if the latest rating was updated within the past week
    final latestRating = query.docs.first;
    final lastRatingTime = latestRating['last_rating'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneWeekAgo = now - (7 * 24 * 60 * 60 * 1000);

    return lastRatingTime >= oneWeekAgo;
  }
}
