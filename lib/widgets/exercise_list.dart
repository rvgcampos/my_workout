import 'package:flutter/material.dart';
import 'package:my_workout/providers/exercise_provider.dart';
import 'package:my_workout/widgets/exercise_card.dart';
import 'package:provider/provider.dart';

class ExerciseList extends StatelessWidget {
  final String workoutId;

  ExerciseList(this.workoutId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ExerciseProvider>(context).get(workoutId),
      builder: (_, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return ExerciseCard(
                    snapshot.data[index].id,
                    snapshot.data[index].name,
                    snapshot.data[index].description,
                    snapshot.data[index].imageUrl,
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
