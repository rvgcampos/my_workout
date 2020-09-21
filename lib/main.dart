import 'package:flutter/material.dart';
import 'package:my_workout/helpers/custom_page_transition.dart';
import 'package:my_workout/providers/auth_provider.dart';
import 'package:my_workout/providers/exercise_provider.dart';
import 'package:my_workout/providers/workout_provider.dart';
import 'package:my_workout/screens/exercise_management_screen.dart';
import 'package:my_workout/screens/exercise_screen.dart';
import 'package:my_workout/screens/home_screen.dart';
import 'package:my_workout/screens/login_screen.dart';
import 'package:my_workout/screens/workout_management_screen.dart';
import 'package:my_workout/screens/workout_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, WorkoutProvider>(
          create: (_) => WorkoutProvider('', ''),
          update: (_, auth, workout) => WorkoutProvider(auth.user, auth.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ExerciseProvider>(
          create: (_) => ExerciseProvider(''),
          update: (_, auth, exercise) => ExerciseProvider(auth.token),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          canvasColor: Colors.transparent,
          accentColor: Color.fromRGBO(0, 223, 100, 1),
          appBarTheme: AppBarTheme(color: Color.fromRGBO(29, 34, 37, 0.9)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardColor: Color.fromRGBO(60, 70, 72, 0.9),
          scaffoldBackgroundColor: Color.fromRGBO(29, 34, 37, 0.9),
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headline4: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyText1: TextStyle(
              color: Colors.white,
            ),
            subtitle1: TextStyle(color: Colors.white),
            subtitle2: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(151, 152, 152, 1),
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Color.fromRGBO(0, 223, 100, 1),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Color.fromRGBO(0, 223, 100, 1),
                ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Color.fromRGBO(48, 56, 62, 0.9),
            filled: true,
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Color.fromRGBO(151, 152, 152, 1),
            ),
          ),
          cursorColor: Color.fromRGBO(0, 223, 100, 1),
          textSelectionHandleColor: Color.fromRGBO(0, 223, 100, 1),
          dialogBackgroundColor: Color.fromRGBO(29, 34, 37, 1),
          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.headline6.fontSize,
            ),
          ),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          }),
        ),
        home: Consumer<AuthProvider>(
          builder: (_, provider, widget) {
            if (provider.token != null) {
              return HomeScreen();
            }
            return LoginScreen();
          },
        ),
        routes: {
          HomeScreen.route: (_) => HomeScreen(),
          WorkoutScreen.route: (_) => WorkoutScreen(),
          WorkoutManagementScreen.route: (_) => WorkoutManagementScreen(),
          ExerciseScreen.route: (_) => ExerciseScreen(),
          ExerciseManagementScreen.route: (_) => ExerciseManagementScreen(),
          LoginScreen.route: (_) => LoginScreen(),
        },
      ),
    );
  }
}
