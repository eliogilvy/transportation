class Place {
  int placeId;
  String licence;
  String osmType;
  int osmId;
  List<String> boundingBox;
  String lat;
  String lon;
  String displayName;
  String classType;
  String type;
  double importance;

  Place({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.boundingBox,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.classType,
    required this.type,
    required this.importance,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      boundingBox: List<String>.from(json['boundingbox']),
      lat: json['lat'],
      lon: json['lon'],
      displayName: json['display_name'],
      classType: json['class'],
      type: json['type'],
      importance: json['importance'].toDouble(),
    );
  }
}
