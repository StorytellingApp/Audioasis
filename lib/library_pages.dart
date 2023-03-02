import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'utils.dart';
import 'verify_email_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class LibraryTabPage extends StatefulWidget {
  const LibraryTabPage({Key? key}) : super(key: key);

  @override
  State<LibraryTabPage> createState() => _LibraryTabPageState();
}

class _LibraryTabPageState extends State<LibraryTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter ,
        children: [
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
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "My Library",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20.0,
                              backgroundImage: AssetImage('images/UserProfilePic.jpg'),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                  ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('signout')),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        PlaylistCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Liked"),
                        SizedBox(width: 8),
                        PlaylistCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Listen Later"),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            "Personal Playlists",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            PlaylistsCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Playlist"),
                            SizedBox(width: 16),
                            PlaylistsCard(image: AssetImage('images/NoImageDefault.jpg'), title: "Playlist"),
                          ],
                        ),
                        SizedBox(height: 16)
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
            SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}

//ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(),
//child: const Text('Sign Out'))

