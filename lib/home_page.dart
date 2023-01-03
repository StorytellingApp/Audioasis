import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged In'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Logged in as')
          ),
          Center(
            child: Text(
              user.email!,
            ),
          ),
          TextButton(onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Logout')
          ),
        ],
      ),
    );
  }
}

