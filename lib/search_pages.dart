import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destudio_test/searchCards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'storyScaffold.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'utils.dart';
import 'verify_email_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'userClasses.dart';

//https://www.youtube.com/watch?v=WbXTl9tiziI

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
        body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
              ], //children
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search for Authors, Stories, Playlist',
                    prefixIcon: Icon(Icons.search)),
                onChanged: (val) {
                  setState(() {
                    storyName = val;
                  });
                },
              ),
            ),

            (searchController.text.isEmpty)
                ? ShowGenres()
                : SizedBox(
                    height: 200,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Stories')
                          .snapshots(),
                      builder: (context, snapshots) {
                        return (snapshots.connectionState ==
                                ConnectionState.waiting)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: snapshots.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshots.data!.docs[index].data()
                                      as Map<String, dynamic>;

                                  if (storyName.isEmpty) {
                                    return Container();
                                  }

                                  if (data['storyName']
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .startsWith(
                                          storyName.trim().toLowerCase())) {
                                    return ListTile(
                                      dense: true,
                                      //TODO: add support for tapping
                                      leading: Image.network(data['art']),
                                      title: Text(
                                        data['storyName'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        data['description'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        //TODO: pass is name and information?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DescriptionStoryPage(
                                                      art: data['art'],
                                                      authorID:
                                                          data['authorID'],
                                                      description:
                                                          data['description'],
                                                      downloadURL:
                                                          data['downloadURL'],
                                                      series: 'false',
                                                      seriesID:
                                                          data['seriesID'],
                                                      storyID: data['storyID'],
                                                      storyName:
                                                          data['storyName'],
                                                      tags: data['tags'],
                                                    )));
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              );
                      },
                    ),
                  ), //TODO: add other page things
          ],
        ),
      ),
    ));
  }
}

class ShowGenres extends StatefulWidget {
  const ShowGenres({Key? key}) : super(key: key);

  @override
  State<ShowGenres> createState() => _ShowGenresState();
}

class _ShowGenresState extends State<ShowGenres> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Discover",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: const Icon(Icons.settings),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              genreCard('Adventure', 'adventure'),
              genreCard('Action', 'action'),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              genreCard('Mystery ', 'mystery'),
              genreCard('Thriller', 'thriller'),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              genreCard('Romance', 'romance'),
              genreCard('Humor', 'humor'),
            ],
          ),

          //TODO: add list here
        ],
      ),
    );
  }

  Widget genreCard(String title, String genre) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShowGenrePage(genre: genre)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const SizedBox(width: 15),
            Image.asset(
              'images/NoImageDefault.jpg',
              width: 50,
            )
          ],
        ),
      ),
    );
  }
}

class ShowGenrePage extends StatefulWidget {
  final String genre;

  const ShowGenrePage({Key? key,
  required this.genre}) : super(key: key);

  @override
  State<ShowGenrePage> createState() => _ShowGenrePageState();
}

class _ShowGenrePageState extends State<ShowGenrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Stories').where('tags',arrayContains: widget.genre)
              .snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState ==
                ConnectionState.waiting)
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshots.data!.docs[index].data()
                as Map<String, dynamic>;


                  return ListTile(
                    dense: true,
                    //TODO: add support for tapping
                    leading: Image.network(data['art']),
                    title: Text(
                      data['storyName'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      data['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      //TODO: pass is name and information?
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DescriptionStoryPage(
                                    art: data['art'],
                                    authorID:
                                    data['authorID'],
                                    description:
                                    data['description'],
                                    downloadURL:
                                    data['downloadURL'],
                                    series: 'false',
                                    seriesID:
                                    data['seriesID'],
                                    storyID: data['storyID'],
                                    storyName:
                                    data['storyName'],
                                    tags: data['tags'],
                                  )));
                    },
                  );
                }


            );
          },
        ),
      ),
    );
  }
}
