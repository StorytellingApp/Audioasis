import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_widget.dart';
import 'home_page.dart';
import 'main.dart';
import 'auth_page.dart';
import 'package:flutter/gestures.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onCLickedSignUp;
  const SignUpWidget({Key? key,
    required this.onCLickedSignUp}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: userNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  labelText: 'Email'
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,
            ),
          ),
          TextButton(
            onPressed: signIn,
            child: const Text('Sign Up'),
          ),
          RichText(
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                text: 'Already have an account?   ',
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onCLickedSignUp,
                      text: 'Log In',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                  )
                ]
            ),
          )
        ],
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
