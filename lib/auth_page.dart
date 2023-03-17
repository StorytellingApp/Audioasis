import 'package:flutter/material.dart';
import 'login_widget.dart';
import 'signup_widget.dart';

//References:
//https://www.youtube.com/watch?v=4vKiJZNPhss

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  //Toggles between login and signup widget
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onCLickedSignUp: toggle)
      : SignUpWidget(onCLickedSignUp: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
