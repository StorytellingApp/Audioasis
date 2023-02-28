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

  const PlayStoryPage({Key? key,
  required this.art,
    required this.authorID,
    required this.description,
    required this.downloadURL,
    required this.series,
    required this.seriesID,
    required this.storyID,
    required this.storyName,
    required this.tags
  }) : super(key: key);

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

