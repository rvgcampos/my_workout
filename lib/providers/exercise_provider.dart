import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_workout/exceptions/api_exception.dart';
import 'package:my_workout/models/exercise.dart';

class ExerciseProvider with ChangeNotifier {
  final String token;
  ExerciseProvider(this.token);

  final String baseUrl = 'https://workoutapp-6e482.firebaseio.com/exercise';

  Future<List<Exercise>> get(String workoutId) async {
    List<Exercise> exercises = [];
    final response = await http.get('$baseUrl.json?auth=$token&orderBy="workoutId"&equalTo="$workoutId"');

    final decoded = json.decode(response.body) as Map<String, dynamic>;

    if (decoded != null) {
      decoded.forEach(
        (key, value) {
          exercises.add(
            Exercise(
              key,
              value['name'],
              value['description'],
              value['imageUrl'],
              value['workoutId'],
            ),
          );
        },
      );
    }

    return exercises;
  }

  Future<void> add(Exercise e) async {
    try {
      final response = await http.post(
        '$baseUrl.json?auth=$token',
        body: json.encode(
          {
            'name': e.name,
            'description': e.description,
            'imageUrl': e.imageUrl,
            'workoutId': e.workoutId,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw ApiException(response.statusCode, response.body);
      }
      notifyListeners();
    } on ApiException catch (api) {
      throw '${api.code} - ${api.message}';
    } catch (e) {
      throw e.message;
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete('$baseUrl/$id.json?auth=$token');

    notifyListeners();
  }
}
