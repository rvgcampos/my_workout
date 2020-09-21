import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_workout/exceptions/api_exception.dart';
import 'package:my_workout/models/workout.dart';

class WorkoutProvider with ChangeNotifier {

  final String userId;
  final String token;

  WorkoutProvider(this.userId, this.token);

  List<Workout> workouts = [];

  final String baseUrl = 'https://workoutapp-6e482.firebaseio.com/workout';

  Future<List<Workout>> get() async {
    try {
      workouts = [];
      final response = await http.get('$baseUrl.json?auth=$token&orderBy="userId"&equalTo="$userId"');

      if (response.statusCode != 200) {
        final message = json.decode(response.body) as Map<String, dynamic>;
        throw ApiException(response.statusCode, message['error']);
      }

      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (decoded != null) {
        decoded.forEach((key, value) {
          workouts.add(
            Workout(
              key,
              value['name'],
              value['imageUrl'],
              value['weekDay'],
            ),
          );
        });
      }

      return workouts;
    } on ApiException catch (api) {
      throw '${api.code} - ${api.message}';
    } catch (e) {
      throw e.message;
    }
  }

  Future<void> add(Workout w) async {
    try {
      final response = await http.post(
        '$baseUrl.json?auth=$token',
        body: json.encode(
          {
            'name': w.name,
            'imageUrl': w.imageUrl,
            'weekDay': w.weekDay,
            'userId': userId,
          },
        ),
      );

      w.id = json.decode(response.body)['name'];
      workouts.add(w);
      notifyListeners();
    } catch (e) {
      throw e.message;
    }
  }

  Future<void> update(Workout w) async {
    final response = await http.put(
      '$baseUrl/${w.id}.json?auth=$token',
      body: json.encode(
        {
          'name': w.name,
          'imageUrl': w.imageUrl,
          'weekDay': w.weekDay,
        },
      ),
    );

    final index = workouts.indexWhere((element) => element.id == w.id);
    workouts[index] = w;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final response = await http.delete('$baseUrl/$id.json?auth=$token');
    workouts.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Workout getById(String id) {
    return workouts.firstWhere((element) => element.id == id);
  }
}
