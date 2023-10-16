import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  bool _isWritting = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('message-private', _listenMessage);
    _loadRecordedMessages(chatService.userFor.uid);
  }

  void _loadRecordedMessages(String uid) async {
    print(uid);
    List<Message> chat = await chatService.getChat(uid);
    print(chat);
    final history = chat.map((m) => new ChatMessage(
        message: m.message,
        uid: m.to,
        animationController: new AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 0),
        )..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = new ChatMessage(
        message: payload['message'],
        uid: payload['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                maxRadius: 14,
                child: Text(
                  'NO',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                chatService.userFor.name,
                style: TextStyle(color: Colors.black87, fontSize: 12),
              )
            ],
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
                reverse: true,
              ),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handeSubmit,
              onChanged: (texto) {
                //TODO: cuando hay un valor, para mostrarlo
                setState(() {
                  if (texto.trim().isNotEmpty) {
                    _isWritting = true;
                  } else {
                    _isWritting = false;
                  }
                });
              },
              decoration:
                  const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
            ),
          ),

          //BOTON ENVIAR

          Container(
            child: Platform.isIOS
                ? CupertinoButton(
                    child: const Text('Enviar'),
                    onPressed: () {},
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        color: Colors.blue[400],
                        onPressed: _isWritting
                            ? () => _handeSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ));
  }

  _handeSubmit(String message) {
    if (message.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      message: message,
      uid: authService.user.uid,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWritting = false;
    });
    socketService.emit('message-private', {
      'from': authService.user.uid,
      'to': chatService.userFor.uid,
      'message': message
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose - of del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('message-private');
    super.dispose();
  }
}
