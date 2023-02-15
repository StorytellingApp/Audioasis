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

  String searchTerm = '';
  Stream<List<Story>> readStory = FirebaseFirestore.instance.collection('Stories')
      .where('storyName'.toLowerCase().trim(),isNotEqualTo: '')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Story.fromJson(doc.data())).toList());

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

  Stream<List<Story>> readStories() => FirebaseFirestore.instance.collection('Stories')
      .where('storyName'.toLowerCase().trim(),isNotEqualTo: searchTerm.toLowerCase().trim())
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Story.fromJson(doc.data())).toList());

  Widget buildStories(Story story) => ListTile(
    leading: const Icon(Icons.book),
    title: Text(story.storyName),
    subtitle: Text(story.description),
  );

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
                  onChanged: (value) {
                    setState(() {
                      searchTerm = searchController.text.trim();
                      readStory = FirebaseFirestore.instance.collection('Stories')
                          .where('storyName'.toLowerCase().trim(),isNotEqualTo: searchTerm.toLowerCase().trim())
                          .snapshots()
                          .map((snapshot) =>
                          snapshot.docs.map((doc) => Story.fromJson(doc.data())).toList());
                    });
                  }
                ),
              ),
              //ElevatedButton(
                  //onPressed: searchQuery,
                  //child: const Text('Search'))
              //Text(searchTerm), Has access to the changes
              StreamBuilder(
                stream: readStory,
                builder: (context,snapshot) {
                  if (snapshot.hasError){
                    return const Text('Something went wrong');
                  }else if (snapshot.hasData){
                    final stories = snapshot.data!;

                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: stories.map(buildStories).toList(),
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator(),);
                  }
                },
              )

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
  Stream<List<Story>> readStories() => FirebaseFirestore.instance.collection('Stories')
      .where('storyName'.toLowerCase(),isEqualTo: widget.searchQuery.toLowerCase().trim())
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Story.fromJson(doc.data())).toList());

  Widget buildStories(Story story) => ListTile(
    leading: const Icon(Icons.book),
    title: Text(story.storyName),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), //Text(widget.searchQuery)
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Results for ${widget.searchQuery}'),
              StreamBuilder(
                stream: readStories(),
                builder: (context,snapshot) {
                  if (snapshot.hasError){
                    return const Text('Something went wrong');
                  }else if (snapshot.hasData){
                    final stories = snapshot.data!;

                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: stories.map(buildStories).toList(),
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator(),);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
