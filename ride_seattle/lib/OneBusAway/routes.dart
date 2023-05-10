import 'keys.dart';

class Routes {
  String getKey() {
    return Key().getOBA();
  }

  String getStopsForRoute(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stops-for-route/$id.xml?key=${getKey()}';
  }
  String getAgencies() {
    return 'http://api.pugetsound.onebusaway.org/api/where/agencies-with-coverage.xml?key=${getKey()}';
  }

  String getRoutes(String id) {
    return 'https://api.pugetsound.onebusaway.org/api/where/routes-for-agency/$id.xml?key=${getKey()}';
  }

  String getStop(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stop/$id.xml?key=${getKey()}';
  }

  String getStopIdsForAgency(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/$id.xml?key=${getKey()}';
  }

  String getVehiclesforAgency(String id) {
    return 'http://api.onebusaway.org/api/where/vehicles-for-agency/$id.xml?key=${getKey()}';
  }

  String getArrivalsAndDepartures(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/$id.xml?key=${getKey()}';
  }

  String getStopsForLocation(String lat, String lon, String radius) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stops-for-location.xml?key=${getKey()}&lat=$lat&lon=$lon&radius=$radius';
  }

  String getRoutesForLocation(String lat, String lon, String radius) {
    return 'http://api.pugetsound.onebusaway.org/api/where/routes-for-location.xml?key=${getKey()}&lat=$lat&lon=$lon&radius=$radius';
  }

  String getTripDetails(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/trip-details/$id.xml?key=${getKey()}';
  }
}
