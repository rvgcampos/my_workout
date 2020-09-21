import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/helpers/custom_page_transition.dart';
import 'package:my_workout/providers/auth_provider.dart';
import 'package:my_workout/screens/home_screen.dart';
import 'package:my_workout/screens/workout_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(29, 36, 41, 0.8),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.home,
                color: Theme.of(context).accentColor,
              ),
              title: Text('Home'),
              onTap: () => Navigator.of(context).pushNamed(
                HomeScreen.route,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.fitness_center,
                color: Theme.of(context).accentColor,
              ),
              title: Text('Treinos'),
              onTap: () => Navigator.of(context).pushNamed(
                WorkoutScreen.route,
              ),
              // onTap: () => Navigator.of(context).push(
              //   CustomPageTransition(
              //     builder: (_) => WorkoutScreen(),
              //   ),
              // ),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).accentColor,
              ),
              title: Text('Sair'),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).popUntil(
                  (route) {
                    if (route.settings.name == '/') {
                      return true;
                    }
                    return false;
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
