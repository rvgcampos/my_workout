import 'package:flutter/material.dart';
import 'package:my_workout/screens/exercise_screen.dart';
import 'package:my_workout/screens/workout_management_screen.dart';
import 'package:my_workout/utils/Utils.dart';
import 'package:my_workout/widgets/workout_screen_custom_clipper.dart';

class WorkoutCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String name;
  final int weekDay;

  WorkoutCard(this.id, this.imageUrl, this.name, this.weekDay);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        WorkoutManagementScreen.route,
        arguments: {
          'title': 'Editando $name',
          'id': id,
        }
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: mediaQuery.size.width * 0.4,
              child: ClipPath(
                clipper: WorkoutScreenCustomClipper(),
                child: Image(
                  image: NetworkImage(
                    imageUrl,
                  ),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    Utils.getWeekdayName(weekDay),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        textTheme: ButtonTextTheme.primary,
                        onPressed: () => Navigator.of(context).pushNamed(
                          ExerciseScreen.route,
                          arguments: {
                            'workoutId': id
                          }
                        ),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(0, 223, 100, 1),
                        ),
                        child: Text('Exercicios'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
