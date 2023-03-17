import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Provides User Library Page

class LibraryTabPage extends StatefulWidget {
  const LibraryTabPage({Key? key}) : super(key: key);

  @override
  State<LibraryTabPage> createState() => _LibraryTabPageState();
}

class _LibraryTabPageState extends State<LibraryTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Overlays items onto color gradient
      body: Stack(
        alignment: Alignment.topCenter ,
        children: [
          //color gradient
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey.withOpacity(0.8),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            //main content
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                            "My Library",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Row(
                          children: const [
                            CircleAvatar(
                              radius: 20.0,
                              //TODO: Temporary image
                              backgroundImage: AssetImage('images/UserProfilePic.jpg'),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  //Signs Users out - this is a temporary button used for testing
                  ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('signout')),
                  //List for liked and listen later
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: const [
                        PlaylistCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Liked"),
                        SizedBox(width: 8),
                        PlaylistCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Listen Later"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                            "Personal Playlists",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            PlaylistsCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Playlist"),
                            SizedBox(width: 16),
                            PlaylistsCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Playlist"),
                          ],
                        ),
                        const SizedBox(height: 16)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

//For displaying playlists
class PlaylistCard extends StatelessWidget {
  final ImageProvider image;
  final String title;
  const PlaylistCard({Key? key, required this.image, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: image,
            width: 240,
            height: 125,
            fit: BoxFit.fitHeight,
        ),
        Text(title),
      ],
    );
  }
}

class PlaylistsCard extends StatelessWidget {
  final AssetImage image;
  final String title;
  const PlaylistsCard({Key? key, required this.image, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        //clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Image(
              image: image,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}

//ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(),
//child: const Text('Sign Out'))

