import 'itinerary.dart';

class Leg {
  final int startTime;
  final int endTime;
  final int departureDelay;
  final int arrivalDelay;
  final bool realTime;
  final double distance;
  final int generalizedCost;
  final bool pathway;
  final String mode;
  final bool transitLeg;
  final int agencyTimeZoneOffset;
  final bool interlineWithPreviousLeg;
  String? routeId;
  final LegGeometry legGeometry;

  Leg({
    required this.startTime,
    required this.endTime,
    required this.departureDelay,
    required this.arrivalDelay,
    required this.realTime,
    required this.distance,
    required this.generalizedCost,
    required this.pathway,
    required this.mode,
    required this.transitLeg,
    required this.agencyTimeZoneOffset,
    required this.interlineWithPreviousLeg,
    required this.legGeometry,
    this.routeId,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    String? route;
    if (json['mode'] == 'BUS') {
      route = json['routeId'];
      route = route!.replaceFirst(':', '_');
      print('route $route');
    } else {
      route = null;
    }
    return Leg(
        startTime: json["startTime"],
        endTime: json["endTime"],
        departureDelay: json["departureDelay"],
        arrivalDelay: json["arrivalDelay"],
        realTime: json["realTime"],
        distance: json["distance"].toDouble(),
        generalizedCost: json["generalizedCost"],
        pathway: json["pathway"],
        mode: json["mode"],
        transitLeg: json["transitLeg"],
        agencyTimeZoneOffset: json["agencyTimeZoneOffset"],
        interlineWithPreviousLeg: json["interlineWithPreviousLeg"],
        legGeometry: LegGeometry.fromJson(json["legGeometry"]),
        routeId: route);
  }
}
