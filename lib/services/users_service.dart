import 'dart:convert';

import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/enviroment.dart';

import 'package:chat_app/models/usuarios.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    String? token = await AuthService.getToken();

    try {
      final response = await http.get(
        Uri.parse('${Enviroment.apiURL}/users/'),
        headers: {
          'Content-type': 'application/json',
          'x-token': token.toString(),
        },
      );

      final usersResponse = usersResponseFromJson(response.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
