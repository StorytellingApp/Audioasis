import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destudio_test/searchCards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'utils.dart';
import 'verify_email_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'userClasses.dart';

class PlayStoryPage extends StatefulWidget {
  final String art;
  final String authorID;
  final String description;
  final String downloadURL;
  final String series;
  final String seriesID;
  final String storyID;
  final String storyName;
  final List<dynamic> tags;

  const PlayStoryPage(
      {Key? key,
      required this.art,
      required this.authorID,
      required this.description,
      required this.downloadURL,
      required this.series,
      required this.seriesID,
      required this.storyID,
      required this.storyName,
      required this.tags})
      : super(key: key);

  @override
  State<PlayStoryPage> createState() => _PlayStoryPageState();
}

class _PlayStoryPageState extends State<PlayStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.storyName),
        ],
      ),
    );
  }
}

class DescriptionStoryPage extends StatefulWidget {
  final String art;
  final String authorID;
  final String description;
  final String downloadURL;
  final String series;
  final String seriesID;
  final String storyID;
  final String storyName;
  final List<dynamic> tags;

  const DescriptionStoryPage(
      {Key? key,
      required this.art,
      required this.authorID,
      required this.description,
      required this.downloadURL,
      required this.series,
      required this.seriesID,
      required this.storyID,
      required this.storyName,
      required this.tags})
      : super(key: key);

  @override
  State<DescriptionStoryPage> createState() => _DescriptionStoryPageState();
}

class _DescriptionStoryPageState extends State<DescriptionStoryPage> {
  final Map<String,dynamic> initialDataStuff = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getAuthorItems(),
          initialData: initialDataStuff,
          builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> authorInfo) {
            if (authorInfo.hasData && !authorInfo.hasError) {
              if (authorInfo.data!.isEmpty) {
                return const Text('No Info Found');
              }else{
                final Map<String,dynamic>? newAuthorInfo = authorInfo.data;
                if (newAuthorInfo == null) {
                  return const Text('Author Does Not Exist');
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(newAuthorInfo['firstName']),
                    ],
                  ),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }

  Future<Map<String,dynamic>> getAuthorItems() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Stories')
        .where('storyID',
        isEqualTo: widget.storyID.toString())
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    final Map<String,dynamic> storyMap = {
      'userID': documents.first['userID'],
      'firstName': documents.first['firstName'],
      'lastName': documents.first['lastName'],
      'imageURL': documents.first['imageURL'],
    };

    return storyMap;
  }
}
