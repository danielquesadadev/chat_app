import 'dart:convert';
import 'dart:math';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuarios.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  late Usuario user;
  bool _authenticating = false;

  bool get authenticating => this._authenticating;
  set authenticating(bool value) {
    this._authenticating = value;
    notifyListeners();
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
      final loginResposne = loginResponseFromJson(response.body);
      this.user = loginResposne.usuario;
      // TODO: Save token
      return true;
    } else {
      return false;
    }
  }
}
