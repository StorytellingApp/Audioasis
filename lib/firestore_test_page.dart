import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destudio_test/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class FirePageTest extends StatefulWidget {
  const FirePageTest({Key? key}) : super(key: key);

  @override
  State<FirePageTest> createState() => _FirePageTestState();
}

class _FirePageTestState extends State<FirePageTest> {
  final firstController = TextEditingController();

  @override
  void dispose(){
    firstController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(controller: firstController,),
              TextButton(
                onPressed: () {
                  final name = firstController.text.trim();

                  createUser(name: name);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createUser({required String name}) async {
    final docTest = FirebaseFirestore.instance.collection('test').doc();

    final json = {
      'name': name,
      'age': 22,
      'birthday':DateTime(2000,5,9),
      'id': docTest.id,
    };

    await docTest.set(json);
  }
}
