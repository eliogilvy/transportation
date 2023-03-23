import 'package:ride_seattle/classes/itinerary.dart';
import 'package:ride_seattle/classes/spot.dart';

class Plan {
  int date;
  Spot to;
  Spot from;
  List<Itinerary> itineraries = [];

  Plan({required this.date, required this.to, required this.from});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      date: json['date'],
      from: Spot.fromJson(json['from']),
      to: Spot.fromJson(json['to']),
    );
  }
}
