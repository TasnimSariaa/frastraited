import 'package:flutter/material.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});



  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:BodyBackground(
        child: Text("login page"),
      ),
    );
  }
}
