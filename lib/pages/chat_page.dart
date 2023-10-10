import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];

  bool _isWritting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
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
                'Noel Quesada',
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

  _handeSubmit(String texto) {
    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      message: texto,
      uid: '1',
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
  }

  @override
  void dispose() {
    // TODO: implement dispose - of del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
