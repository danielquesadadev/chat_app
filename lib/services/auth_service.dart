import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuarios.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _authenticating = false;
  final _storage = const FlutterSecureStorage();

  bool get authenticating => this._authenticating;
  set authenticating(bool value) {
    this._authenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = const FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.authenticating = true;

    final data = {'email': email, 'password': password};

    final response = await http.post(
      Uri.parse('${Enviroment.apiURL}/login'),
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    );

    this.authenticating = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;

      await _saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.authenticating = true;

    final data = {'name': name, 'email': email, 'password': password};

    final response = await http.post(
      Uri.parse('${Enviroment.apiURL}/login/new'),
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    );

    this.authenticating = false;

    if (response.statusCode == 200) {
      final registerResponse = loginResponseFromJson(response.body);
      this.user = registerResponse.user;

      await _saveToken(registerResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(response.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('${Enviroment.apiURL}/login/renew'),
      headers: {'Content-type': 'application/json', 'x-token': token},
    );

    if (response.statusCode == 200) {
      final registerResponse = loginResponseFromJson(response.body);
      this.user = registerResponse.user;

      await _saveToken(registerResponse.token);

      return true;
    } else {
      _logout(token);
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout(String token) async {
    await _storage.delete(key: 'token');
  }
}
