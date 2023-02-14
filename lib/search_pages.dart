import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'utils.dart';
import 'verify_email_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class SearchTabPage extends StatefulWidget {
  const SearchTabPage({Key? key}) : super(key: key);

  @override
  State<SearchTabPage> createState() => _SearchTabPageState();
}

class _SearchTabPageState extends State<SearchTabPage> {
  final searchController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  Future signOut() async {
    FirebaseAuth.instance.signOut();
  }

  void searchQuery() {
    final isValid = searchKey.currentState!.validate();
    if (!isValid) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            SearchResults(searchQuery: searchController.text) //Works
        ));
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
                child: TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(labelText: 'Search'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.isEmpty ? 'Enter a Search Term' : null,
                ),
              ),
              ElevatedButton(
                  onPressed: searchQuery,
                  child: const Text('Search'))
            ],
          ),
        ),
      ),
    );
  }
}

//Displays the actual results
class SearchResults extends StatefulWidget {
  final String searchQuery;

  const SearchResults({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text(widget.searchQuery),
    );
  }
}
