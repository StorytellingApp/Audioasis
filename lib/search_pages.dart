import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'storyScaffold.dart';
//https://www.youtube.com/watch?v=WbXTl9tiziI

class SearchTabPage extends StatefulWidget {
  const SearchTabPage({Key? key}) : super(key: key);

  @override
  State<SearchTabPage> createState() => _SearchTabPageState();
}

class _SearchTabPageState extends State<SearchTabPage> {
  final searchController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  //initial story name - empty means nothing is searched for
  //changes based on search controller
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
            //Actual search bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search for Authors, Stories, Playlist',
                    prefixIcon: Icon(Icons.search)),
                onChanged: (val) {
                  setState(() {
                    //assigns search to storyname
                    storyName = val;
                  });
                },
              ),
            ),

            //changes page content based on if it is being searched or not
            //show genres only if search bar is empty - rldr display search
            (searchController.text.isEmpty)
                ? ShowGenres()
                : SizedBox(
              //returns result of search
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
                          //creates list
                                itemCount: snapshots.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshots.data!.docs[index].data()
                                      as Map<String, dynamic>;
                                  //if search empty - return nothing
                                  if (storyName.isEmpty) {
                                    return Container();
                                  }

                                  //only display story if name matches with search
                                  if (data['storyName']
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .startsWith(
                                          storyName.trim().toLowerCase())) {
                                    //generates list tile result - how it is shown
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
                                        //on tap -goes to play story page
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
//card that shows genres
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
            //each card acts the same - see below
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

  //shows the actual display - navigates to separate page to show genre
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

//shows genre via list
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
          //query FIrebase for only stories that contain the selected genre
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


                //eventually leads to same play page as search list does
                  return ListTile(
                    dense: true,
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
                      //goes to play page - same page essentially as one from search
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
