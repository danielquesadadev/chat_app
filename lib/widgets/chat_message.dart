import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {super.key,
      required this.message,
      required this.uid,
      required AnimationController animationController})
      : animationController = animationController;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController, curve: Curves.elasticOut),
        child: Container(
          child: uid == '1' ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 35, 113, 192),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
