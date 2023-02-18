//Use for the home pages and all associated things
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'utils.dart';
import 'verify_email_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    var slider;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text(
                'Home',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal
                ),
              ),
              //TODO fix spacing between notification icon and profile also have to make profile clickable
              IconButton(//notficiations
                  onPressed: () {},
                icon: Icon(Icons.notifications, color: Colors.black,),
              ),
              const CircleAvatar(//profile
                radius: 20.0,
                backgroundImage: AssetImage('images/UserProfilePic.jpg'),
              ),
            ],
          ), //home title
          const SizedBox(
            height: 15.0,
          ),
          const Text(
            "Recently Played",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (
                    (context, index) {

                      return Column(
                        children: [
                          Container(//cards for stories
                            height: 125,
                            width: 240,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(//create box for story card
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                             // image: DecorationImage(
                               // image: AssetImage((['image']),
                               // ),
                               // fit: BoxFit.cover
                              ),
                            ),

                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Title',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.normal
                          ),
                          ),
                        ],//children
                      );

                    }),
                ),
              ),

        ],
      ),
    );
  }
}
