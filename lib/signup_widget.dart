import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_widget.dart';
import 'home_page.dart';
import 'main.dart';
import 'auth_page.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'utils.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onCLickedSignUp;
  const SignUpWidget({Key? key,
    required this.onCLickedSignUp}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
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
      child: Form(
        key: formKey,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: userNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  labelText: 'Email'
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
              email != null && !EmailValidator.validate(email)
              ? 'Enter a valid email'
              : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
              ? 'Enter 6 characters minimum'
              : null,
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
      )
    );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }
}
