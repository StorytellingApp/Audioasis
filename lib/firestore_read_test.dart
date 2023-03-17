import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

//Depricated - no longer in use
//Was used to test reading from Firestore

//References
//https://www.youtube.com/watch?v=ErP_xomHKTw

class FirestoreWriteTest extends StatefulWidget {
  const FirestoreWriteTest({Key? key}) : super(key: key);

  @override
  State<FirestoreWriteTest> createState() => _FirestoreWriteTestState();
}

class _FirestoreWriteTestState extends State<FirestoreWriteTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Data'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<TestUser>>(
                stream: readTestUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;

                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: users.map(buildTestUser).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTestUser(TestUser user) => ListTile(
        leading: CircleAvatar(
          child: Text(user.age),
        ),
        title: Text(user.name),
        subtitle: Text(user.birthday),
      );

  Stream<List<TestUser>> readTestUsers() => FirebaseFirestore.instance
      .collection('test')
      .where('age', isEqualTo: '40')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => TestUser.fromJson(doc.data())).toList());

  Stream<Iterable<String>> getNames() {
    final test = FirebaseFirestore.instance.collection('test').snapshots();
    return test
        .map((snapshot) => snapshot.docs.map((doc) => doc.data().toString()));
  }
}

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Stories').snapshots(),
      builder: (context, snapshots) {
        return (snapshots.connectionState == ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;

                  if (snapshots.data!.docs.isEmpty) {
                    return Container();
                  }

                  if (data['authorID']
                      .toString()
                      .trim()
                      .toLowerCase()
                      .startsWith(FirebaseAuth.instance.currentUser!.uid
                          .toString()
                          .trim())) {
                    return ListTile(
                      //TODO: add support for tapping
                      title: Text(
                        data['seriesName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }
                  return Container();
                },
              );
      },
    );
  }
}

