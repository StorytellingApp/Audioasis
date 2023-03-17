import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'utils.dart';
import 'verify_email_page.dart';

//References:
//https://www.youtube.com/watch?v=4vKiJZNPhss

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //Initialize firebase

  runApp(const MyApp());
}

//for snackbars and other navigation - needs to be global
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //sets up designs
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      title: 'Audioasis',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

//this is the very first page reached
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), //listens to changes in pages
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Connection Error'));
        } else if (snapshot.hasData){
          //will go here if waiting on email verification
          return const VerifyEmailPage();
        } else {
          //goes here else
          return const AuthPage();
        }
      },
    )
  );
}

