import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: const ValueKey("navigation_drawer"),
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            Expanded(child: buildMenuItems(context)),
          ],
        ));
  }
}

Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ));

Widget buildMenuItems(BuildContext context) {
  final fire = Provider.of<FireProvider>(context);
  final iconColor = Theme.of(context).colorScheme.onPrimaryContainer;
  final containerColor = Theme.of(context).colorScheme.primaryContainer;
  final textStyle = Theme.of(context).primaryTextTheme.titleLarge;
  final secondary = Theme.of(context).colorScheme.secondary;
  return Container(
    color: containerColor,
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Home
        ListTile(
          leading: Icon(Icons.home_outlined, color: iconColor),
          title: Text(
            'Home',
            style: textStyle,
          ),
          onTap: () {
            context.pop();
          },
        ),
        Divider(color: secondary),
        //My Routes
        ListTile(
          leading: Icon(Icons.star_border, color: iconColor),
          title: Text(
            'My Routes',
            style: textStyle,
          ),
          onTap: () {
            context.push('/favoriteRoutes');
          },
        ),
        Divider(
          color: secondary,
        ),
        ListTile(
          key: const ValueKey("route_history"),
          leading: Icon(
            Icons.history_rounded,
            color: iconColor,
          ),
          title: Text('History', style: textStyle),
          onTap: () {
            context.push('/history');
          },
        ),
        // Divider(color: Theme.of(context).dividerColor),
        // ListTile(
        //   key: const ValueKey("pay"),
        //   leading: Icon(
        //     Icons.payment,
        //     color: Theme.of(context).primaryColorDark,
        //   ),
        //   title: Text(
        //     'Buy a Ticket',
        //     style: Theme.of(context).primaryTextTheme.bodyMedium,
        //   ),
        //   onTap: () {
        //     context.push('/payment');
        //   },
        // ),

        Expanded(child: Container()),
        Divider(color: secondary),

        //Settings
        ListTile(
          leading: Icon(
            Icons.settings,
            color: iconColor,
          ),
          title: Text(
            'Settings',
            style: textStyle,
          ),
          onTap: () {
            context.push('/settings');
          },
        ),
      ],
    ),
  );
}
