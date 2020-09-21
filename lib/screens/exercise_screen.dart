import 'package:flutter/material.dart';
import 'package:my_workout/screens/exercise_management_screen.dart';
import 'package:my_workout/widgets/exercise_list.dart';

class ExerciseScreen extends StatelessWidget {
  static const String route = '/exercise';

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios cadastrados'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(
              ExerciseManagementScreen.route,
              arguments: arguments,
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/bg4.jpg'),
              fit: BoxFit.cover,
            )),
          ),
          ExerciseList(arguments['workoutId']),
        ],
      ),
    );
  }
}
