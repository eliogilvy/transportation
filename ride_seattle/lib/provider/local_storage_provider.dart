import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

import '../classes/old_stops.dart';

class LocalStorageProvider extends ChangeNotifier {
  late Box<OldStops> history;

  LocalStorageProvider(Box<OldStops> h) {
    history = h;
  }
}
