import 'package:flutter/material.dart';
import 'package:my_workout/providers/workout_provider.dart';
import 'package:my_workout/screens/workout_management_screen.dart';
import 'package:my_workout/widgets/app_drawer.dart';
import 'package:my_workout/widgets/workout_card.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatelessWidget {
  static const route = '/workout';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(
              WorkoutManagementScreen.route,
              arguments: {'title': 'Novo Treino'},
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Consumer<WorkoutProvider>(
            builder: (_, provider, widget) {
              return ListView.builder(
                itemCount: provider.workouts.length,
                itemBuilder: (_, index) {
                  return WorkoutCard(
                    provider.workouts[index].id,
                    provider.workouts[index].imageUrl,
                    provider.workouts[index].name,
                    provider.workouts[index].weekDay,
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
