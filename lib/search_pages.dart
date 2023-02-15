import 'package:cloud_firestore/cloud_firestore.dart';
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


class SearchTabPage extends StatefulWidget {
  const SearchTabPage({Key? key}) : super(key: key);

  @override
  State<SearchTabPage> createState() => _SearchTabPageState();
}

class _SearchTabPageState extends State<SearchTabPage> {
  final searchController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  String storyName = '';


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Form(
        key: searchKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(labelText: 'Search'),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}


