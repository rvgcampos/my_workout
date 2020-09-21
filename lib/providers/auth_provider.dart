import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final String baseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  final String key = 'AIzaSyDPCyIAeVUq3vNAoEgnMw-V-gp96QQVoOQ';

  String _userId;
  String _token;

  String get user {
    return _userId;
  }

  String get token {
    return _token;
  }

  Future<void> manageAuth(email, password, action) async {
    try {
      final response = await http.post(
        '$baseUrl$action?key=$key',
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        if (decoded['error']['message'] == 'EMAIL_EXISTS') {
          throw Exception('Email já cadastrado');
        } else if (decoded['error']['message'] == 'INVALID_EMAIL') {
          throw Exception('Email inválido');
        } else if (decoded['error']['message'] == 'WEAK_PASSWORD') {
          throw Exception('Senha muito fraca');
        } else if (decoded['error']['message'] == 'EMAIL_NOT_FOUND') {
          throw Exception('Email não encontrado');
        } else if (decoded['error']['message'] == 'INVALID_PASSWORD') {
          throw Exception('Senha inválida');
        }
      }

      if (response.statusCode == 200 && action == 'signInWithPassword') {
        print(decoded);
        _userId = decoded['localId'];
        _token = decoded['idToken'];
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void logout(){
    _userId = null;
    _token = null;
    notifyListeners();
  }
}
