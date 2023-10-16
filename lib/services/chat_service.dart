import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/usuarios.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late User userFor;
  Future getChat(String userId) async {
    String? token = await AuthService.getToken();
    final resp = await http
        .get(Uri.parse('${Enviroment.apiURL}/messages/$userId'), headers: {
      'Content-Type': 'application/json',
      'x-token': token.toString()
    });
    final messagesResp = messagesResponseFromJson(resp.body);
    return messagesResp.messages;
  }
}
