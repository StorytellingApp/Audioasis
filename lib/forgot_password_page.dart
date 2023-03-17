import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils.dart';

//References:
//https://www.youtube.com/watch?v=4vKiJZNPhss

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //Controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Reset Password', style: TextStyle(fontSize: 14),),
              TextFormField(
                //For getting email
                controller: emailController,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                ? 'Enter a valid email'
                : null,
              ),
              TextButton(
                onPressed: resetPassword,
                child: const Text('Reset Password'),
              )
            ],
          ),
        )
      ),
    );
  }

  Future resetPassword() async {
    //sends email reset

    //creates circularprogressindicator
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(),)
    );

    try {
      //sends reset email
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
      //Hide CircularProgressIndicator
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {

      //Show errors
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
