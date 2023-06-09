import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/Screens/otp.dart';
import 'package:ride_seattle/Screens/settings.dart';
import 'package:ride_seattle/Screens/stop_history.dart';
import 'package:ride_seattle/classes/old_stops.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'package:ride_seattle/provider/google_maps_provider.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:ride_seattle/provider/nav_provider.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/provider/theme_provider.dart';
import 'package:ride_seattle/styles/theme.dart';
import 'package:ride_seattle/widgets/enter_phone_number.dart';
import 'Screens/admin.dart';
import 'Screens/favorites_screen.dart';
import 'Screens/payment_screen.dart';
import 'classes/auth.dart';
import 'provider/state_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/check_auth.dart';
import 'package:flutter/services.dart';

late Box<OldStops> history;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load();
  //initialize hive offline storage
  await Hive.initFlutter();
  Hive.registerAdapter(OldStopsAdapter());
  //openboxes
  history = await Hive.openBox('old_stops');
  var fb = FirebaseFirestore.instance;

  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  Client client = Client();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => StateInfo(locator: locator, client: client)),
        ChangeNotifierProvider(create: (context) => RouteProvider()),
        ListenableProvider<LocalStorageProvider>(
          create: (context) => LocalStorageProvider(history),
        ),
        ChangeNotifierProvider<FireProvider>(
          create: (context) => FireProvider(
            fb: fb,
            auth: Auth(firebaseAuth: FirebaseAuth.instance),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<MapsProvider>(
          create: (context) => MapsProvider(),
        ),
        ChangeNotifierProvider<NavProvider>(
          create: (context) => NavProvider(),
        ),
      ],
      child: const RideApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CheckAuth(),
      routes: const [],
    ),
    GoRoute(
      path: '/favoriteRoutes',
      builder: (context, state) => const Favorites(),
      routes: const [],
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const StopHistory(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentPage(),
    ),
    GoRoute(
      name: 'phone_auth',
      path: '/phone_auth',
      builder: (context, state) => PhoneSignIn(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final map = state.extra as Map;
        final callback = map['callback'] as Function;
        final verificationId = map['verificationId'] as String;
        return OtpScreen(callback: callback, verificationId: verificationId);
      },
    ),
    GoRoute(
        path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(
      path: '/admin',
      builder: (context, state) => AdminScreen(),
    ),
  ],
);

class RideApp extends StatelessWidget {
  const RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'Ride App',
      routerConfig: _router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: theme.themeMode,
    );
  }
}
