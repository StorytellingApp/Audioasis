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
  final secondController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose(){
    firstController.dispose();
    secondController.dispose();
    dateController.dispose();

    super.dispose();
  }

  //TODO: add validation

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
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(controller: firstController,
                  decoration: const InputDecoration(border: OutlineInputBorder(),
                      hintText: 'Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(controller: secondController,
                  decoration: const InputDecoration(border: OutlineInputBorder(),
                      hintText: 'Age'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(controller: dateController,
                  decoration: const InputDecoration(border: OutlineInputBorder(),
                      hintText: 'Birth Year'),
                ),
              ),
              TextButton(
                onPressed: () {
                  final name = firstController.text.trim();
                  final age = secondController.text.trim();
                  final year = dateController.text.trim();

                  createUser(name: name, age: age, birthYear: year);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createUser({required String name, required String age, required String birthYear}) async {
    final docTest = FirebaseFirestore.instance.collection('test').doc();

    final json = {
      'name': name,
      'age': age,
      'birthday':birthYear,
      'id': docTest.id,
    };

    await docTest.set(json);
  }
}
