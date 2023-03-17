import 'dart:async';
import 'package:destudio_test/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

//References:
//https://www.youtube.com/watch?v=4vKiJZNPhss

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false; //for preventing constant resending of emails
  Timer? timer;

  @override
  void initState() {
    super.initState();

    //User created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    //sends initial verification emai;
    if (!isEmailVerified) {
      sendVerificationEmail();

      //this checks every 3 seconds for email is verified
      timer = Timer.periodic(
        const Duration(seconds: 3),
          (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //This method is called to check verification
  Future checkEmailVerified() async {
    //call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    //stops timer
    if (isEmailVerified) timer?.cancel();
  }

  //sends email
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() =>canResendEmail = false);
      //prevents constant resending of email
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);

    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage() //if email verified, go home - else, wait on verification
      : Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Verification email has been sent', style: TextStyle(fontSize: 20),),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: canResendEmail ? sendVerificationEmail : null,
              child: const Text('Resend Email'),
            ),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Cancel'),
            )
          ],
        ),
      );
}
