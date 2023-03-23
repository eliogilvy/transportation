import 'package:ride_seattle/classes/itinerary.dart';

class Spot {
  String name;
  double lon;
  double lat;
  String vertexType;

  Spot({
    required this.name,
    required this.lon,
    required this.lat,
    required this.vertexType,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      name: json['name'],
      lon: json['lon'],
      lat: json['lat'],
      vertexType: json['vertexType'],
    );
  }
}
