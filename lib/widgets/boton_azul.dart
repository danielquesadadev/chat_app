import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final Function() onPressed;

  BotonAzul({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(child: Text(text)),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
    );
  }
}
