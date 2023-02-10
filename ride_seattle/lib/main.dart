import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'Pages/current_location_screen.dart';
import 'Pages/home.dart';
import 'provider/state_info.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  var stateInfo = StateInfo();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: stateInfo),
      ],
      child: rideApp(),
    ),
  );
}


final _router = GoRouter(
    initialLocation: '/',
    routes:[
      GoRoute(
        path:'/',
        builder: (context, state) => const CurrentLocationScreen(),
        routes: [],
      ),
    ],
);


class rideApp extends StatelessWidget {

  const rideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ride App',
      routerConfig: _router,
    );
  }
}

