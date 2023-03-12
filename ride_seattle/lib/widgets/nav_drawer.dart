import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../classes/auth.dart';

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

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Home
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              context.pop();
            },
          ),
          Divider(color: Theme.of(context).dividerColor),
          //My Routes
          ListTile(
            leading: Icon(
              Icons.star_border,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text(
              'My Routes',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              context.push('/favoriteRoutes');
            },
          ),

          Expanded(child: Container()),
          Divider(color: Theme.of(context).dividerColor),
          //Sign Out
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text(
              'Sign out',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () async {
              await Auth().signOut();
            },
          ),
        ],
      ),
    );
