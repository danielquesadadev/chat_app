import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  String emailCtrl;
  String passCtrl;

  BotonAzul({super.key. email});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print(emailText);
        print(passText);
      },
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(child: Text('Ingresar')),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: StadiumBorder(),
      ),
    );
  }
}
