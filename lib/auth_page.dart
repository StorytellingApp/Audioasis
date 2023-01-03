import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_widget.dart';
import 'home_page.dart';
import 'main.dart';
import 'signup_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onCLickedSignUp: toggle)
      : SignUpWidget(onCLickedSignUp: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
