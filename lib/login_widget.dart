import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'utils.dart';
import 'forgot_password_page.dart';

//References:
//https://www.youtube.com/watch?v=4vKiJZNPhss

class LoginWidget extends StatefulWidget {
  final VoidCallback onCLickedSignUp;
  const LoginWidget({Key? key,
  required this.onCLickedSignUp}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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
    return MaterialApp(
      // padding: const EdgeInsets.all(16),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage('images/Classy-Logo-AO.jpg'),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: userNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                    prefixIcon: Icon(Icons.email)
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
              ),
              GestureDetector(
                child: Text(
                  'Forgot Password?',
                  // textAlign: TextAlign.right, (NEED TO FIND A WAY TO ALIGN FORGOT PASS TO THE RIGHT)
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage()
                )),
              ),
              TextButton(
                onPressed: signIn,
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              //   GestureDetector(
              //     child: Text(
              //       'Forgot Password?',
              //       style: TextStyle(
              //         decoration: TextDecoration.underline,
              //         color: Theme.of(context).colorScheme.secondary,
              //         fontSize: 16,
              //       ),
              //     ),
              //     onTap: () => Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => ForgotPasswordPage()
              //   )),
              // ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  text: 'No Account?   ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onCLickedSignUp,
                      text: 'Sign Up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          )

        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
