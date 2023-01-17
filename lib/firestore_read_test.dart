import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destudio_test/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class FirestoreWriteTest extends StatefulWidget {
  const FirestoreWriteTest({Key? key}) : super(key: key);

  @override
  State<FirestoreWriteTest> createState() => _FirestoreWriteTestState();
}

class _FirestoreWriteTestState extends State<FirestoreWriteTest> {
  CollectionReference users = FirebaseFirestore.instance.collection('test');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Data'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: users.doc('1qy43kRjgFPqHWCnBDkL').get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.hasData && !snapshot.data!.exists){
                  return const Text('Document Does Not Exist');
                }

                if (snapshot.connectionState == ConnectionState.done){
                  Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
                  return Text("Name: ${data['name']}");
                }

                return Text('loading');
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<Iterable<String>> getNames() {
    final test =  FirebaseFirestore.instance.collection('test').snapshots();
    return test.map((snapshot) => snapshot.docs.map((doc) => doc.data().toString()));
  }
}
