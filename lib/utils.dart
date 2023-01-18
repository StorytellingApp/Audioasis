import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text){
    if (text == null) return;
    
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red,);

    messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
  }
}

class TestUser {
  String id;
  final String name;
  final String age;
  final String birthday;

  TestUser({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'birthday': birthday,
  };

  static TestUser fromJson(Map<String, dynamic> json) => TestUser(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    birthday: json['birthday'],
  );
}

//Check https://firebase.flutter.dev/docs/firestore/usage/ for 'ArrayContains'