import 'dart:convert';

import 'package:ride_seattle/OneBusAway/keys.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ride_seattle/classes/itinerary.dart';

import '../classes/place.dart';

class OtpHelper {
  OtpHelper();
  final String key = Key.otp;
  final String otpBase = 'http://10.0.0.60:8080/otp/routers/default/';
  final String addressBase = 'http://nominatim.openstreetmap.org/search?';
  final String view = '-122.435,47.495,-122.234,47.734';
  final String format = 'json';
  final String limit = '10';

  Future<List<Itinerary>> getTripPlan(String from, String to) async {
    List<Itinerary> list = [];
    String time = DateFormat.jm().format(DateTime.now());
    String date = DateFormat('MM-dd-yyyy').format(DateTime.now());
    String url =
        '${otpBase}plan?fromPlace=$from&toPlace=$to&time=$time&date=$date&mode=TRANSIT,WALK';
    print('getting $url');
    Response res = await get(Uri.parse(url));
    Map<String, dynamic> body = jsonDecode(res.body);
    Map<String, dynamic> plan = body['plan'];

    List itineraries = plan['itineraries'];
    for (var i in itineraries) {
      list.add(Itinerary.fromJson(i));
    }
    return list;
  }

  Future<List<Place>> getAddresses(String query) async {
    String url =
        '${addressBase}q=$query+Seattle&format=$format&viewbox=$view&limit=$limit';
    print('getting $url');
    Response res = await get(Uri.parse(url));
    List addressList = jsonDecode(res.body);

    List<Place> places =
        addressList.map((place) => Place.fromJson(place)).toList();
    return places;
  }
}
