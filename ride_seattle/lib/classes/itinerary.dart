import 'leg.dart';

class Itinerary {
  final int duration;
  final int startTime;
  final int endTime;
  final int walkTime;
  final int transitTime;
  final int waitingTime;
  final double walkDistance;
  final bool walkLimitExceeded;
  final int generalizedCost;
  final double elevationLost;
  final double elevationGained;
  final int transfers;
  final Map<String, dynamic> fare;
  final List<Leg> legs;

  Itinerary({
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.walkTime,
    required this.transitTime,
    required this.waitingTime,
    required this.walkDistance,
    required this.walkLimitExceeded,
    required this.generalizedCost,
    required this.elevationLost,
    required this.elevationGained,
    required this.transfers,
    required this.fare,
    required this.legs,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    List list = json['legs'];
    List<Leg> legs = [];
    for (var leg in list) {
      legs.add(Leg.fromJson(leg));
    }
    return Itinerary(
      duration: json['duration'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      walkTime: json['walkTime'],
      transitTime: json['transitTime'],
      waitingTime: json['waitingTime'],
      walkDistance: json['walkDistance'],
      walkLimitExceeded: json['walkLimitExceeded'],
      generalizedCost: json['generalizedCost'],
      elevationLost: json['elevationLost'],
      elevationGained: json['elevationGained'],
      transfers: json['transfers'],
      fare: json['fare'],
      legs: legs,
    );
  }
}

class LegGeometry {
  final String points;
  final int length;

  LegGeometry({
    required this.points,
    required this.length,
  });

  factory LegGeometry.fromJson(Map<String, dynamic> json) =>
      LegGeometry(points: json['points'], length: json['length']);
}
