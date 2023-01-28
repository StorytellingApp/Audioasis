import 'package:destudio_test/userClasses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'utils.dart';

//References:
//https://www.youtube.com/watch?v=4vKiJZNPhss

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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

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
              textInputAction: TextInputAction.next,
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
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: firstNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'First Name'
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.isEmpty
              ? 'Enter a Name'
              : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: lastNameController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Last Name'
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.isEmpty
              ? 'Enter a Name'
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

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );

      //Added for creating user info
      final userID = FirebaseAuth.instance.currentUser!.uid;
      print(userID);

      final test = AppUser(userID: userID, firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(), imageURL: '');
      final docTest = FirebaseFirestore.instance.collection('Users').doc(userID);
      docTest.set(test.toJson());

    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
