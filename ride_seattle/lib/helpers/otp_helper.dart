import 'dart:convert';

import 'package:ride_seattle/OneBusAway/keys.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ride_seattle/classes/itinerary.dart';

import '../classes/place.dart';
import '../classes/plan.dart';

class OtpHelper {
  OtpHelper();
  final String key = Key().getOTP();
  final String otpBase = 'http://10.0.0.60:8080/otp/routers/default/';
  final String addressBase = 'http://nominatim.openstreetmap.org/';
  final String view = '-122.435,47.495,-122.234,47.734';
  final String format = 'json';
  final String limit = '10';

  Future<Plan> getTripPlan(String from, String to) async {
    List<Itinerary> list = [];
    String time = DateFormat.jm().format(DateTime.now());
    String date = DateFormat('MM-dd-yyyy').format(DateTime.now());
    String url =
        '${otpBase}plan?fromPlace=$from&toPlace=$to&time=$time&date=$date&mode=TRANSIT,WALK';
    Response res = await get(Uri.parse(url));
    Map<String, dynamic> body = jsonDecode(res.body);
    Map<String, dynamic> plan = body['plan'];
    Plan p = Plan.fromJson(plan);

    List itineraries = plan['itineraries'];
    for (var i in itineraries) {
      list.add(Itinerary.fromJson(i));
    }
    p.itineraries = list;

    return p;
  }

  Future<List<Place>> getAddresses(String query) async {
    String url =
        '${addressBase}search?q=$query&city=Seattle&state=Washington&format=$format&viewbox=$view&limit=$limit';
    Response res = await get(Uri.parse(url));
    List addressList = jsonDecode(res.body);

    List<Place> places =
        addressList.map((place) => Place.fromJson(place)).toList();
    return places;
  }

  Future<String> getAddress(double lat, double lon) async {
    String url =
        '${addressBase}reverse?lat=${lat.toString()}&lon=${lon.toString()}&format=$format';
    Response res = await get(Uri.parse(url));
    Map<String, dynamic> body = jsonDecode(res.body);
    Map<String, dynamic> address = body['address'];
    return '${address['house_number']} ${address['road']}';
  }
}
