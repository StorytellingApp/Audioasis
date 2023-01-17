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

class PlaylistTest {
  Map<String,String> stories = {};

  void addItem({required String name, required String downloadURL}){
    Map<String,String> temp = {name: downloadURL};
    stories.addAll(temp);
  }

  Iterable<MapEntry<String,String>> getItems() {
    return stories.entries;
  }

}