import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/models/workout.dart';
import 'package:my_workout/providers/workout_provider.dart';
import 'package:my_workout/utils/Utils.dart';
import 'package:my_workout/widgets/app_drawer.dart';
import 'package:my_workout/widgets/exercise_list.dart';
import 'package:my_workout/widgets/today_workout.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _weekDay = DateTime.now().weekday;

  List<FlatButton> _getButtonBar() {
    List<FlatButton> _list = [];
    for (int i = 1; i < 8; i++) {
      _list.add(
        FlatButton(
          onPressed: () {
            setState(() {
              _weekDay = i;
            });
          },
          child: Text(
            Utils.getWeekdayName(i).substring(0, 3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              style: BorderStyle.solid,
              color: Theme.of(context).accentColor,
            ),
          ),
          color: _weekDay == i ? Theme.of(context).accentColor : Colors.transparent,
          textColor: _weekDay == i ? Colors.white : Theme.of(context).accentColor,
        ),
      );
    }
    return _list;
  }

  Widget _getTodayWorkout(List<Workout> workouts) {
    final index = workouts.indexWhere((element) => element.weekDay == _weekDay);
    if (index != -1) {
      return TodayWorkout(workouts[index].name, workouts[index].imageUrl);
    } else {
      return Center(
        child: Text(
          'Nenhum treinamento encontrado para o dia selecionado.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Widget _getExercisesList(List<Workout> workouts) {
    final index = workouts.indexWhere((element) => element.weekDay == _weekDay);
    if (index != -1) {
      return Expanded(
        child: ExerciseList(workouts[index].id),
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/bg3.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          FutureBuilder(
            future: Provider.of<WorkoutProvider>(context, listen: false).get(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.error != null) {
                  return Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 80,
                          ),
                          Text(
                            "${snapshot.error}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Consumer<WorkoutProvider>(
                      builder: (_, provider, widget) {
                        return Column(
                          children: [
                            widget,
                            _getTodayWorkout(provider.workouts),
                            _getExercisesList(provider.workouts),
                          ],
                        );
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ButtonBar(
                          children: _getButtonBar(),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
