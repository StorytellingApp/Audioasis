//Use for the home pages and all associated things

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


class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class SearchCards {
  final String url;
  final String author;
  final String storyTitle;

  const SearchCards({
    required this.url,
    required this.author,
    required this.storyTitle
  });
}


class _HomeTabPageState extends State<HomeTabPage> {

  List<SearchCards> items = [
    const SearchCards(
      url: 'https://cdn.britannica.com/83/156583-050-4A1FABB5/Red-raspberries.jpg',
      author: 'Edgar',
      storyTitle: 'Raspberry',
    ),
    const SearchCards(url: "https://media.istockphoto.com/id/505161000/photo/spam.jpg?s=612x612&w=0&k=20&c=Tof-sfyPZ0KtdvpumWdfaChOTHuRXN6jNhqzvlrhTFI=",
      author: 'SammyTheSpam',
      storyTitle: 'All about Spam',
    ),
    const SearchCards(
      url: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d1b8154e-56f8-417d-b243-5fba52b4890e/d2ojazn-a113192c-9f46-4aac-af07-b0470f02d840.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2QxYjgxNTRlLTU2ZjgtNDE3ZC1iMjQzLTVmYmE1MmI0ODkwZVwvZDJvamF6bi1hMTEzMTkyYy05ZjQ2LTRhYWMtYWYwNy1iMDQ3MGYwMmQ4NDAuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.m2JA5w8U_pWdLpRKCmHqf5-remJfIMXbi9Ggr4_FW2k",
      author: 'Osteraloa',
      storyTitle: 'La Cucaracha',
    ),
    const SearchCards(
      url: "https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bG92ZSUyMGhlYXJ0fGVufDB8fDB8fA%3D%3D&w=1000&q=80",
      author: 'Masf',
      storyTitle: 'I Love you',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              IconButton( //notficiations
                onPressed: () {},
                icon: Icon(Icons.notifications, color: Colors.black,),
              ),
              const CircleAvatar( //profile
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
                        Container( //cards for stories
                          height: 125,
                          width: 240,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration( //create box for story card
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
                      ], //children
                    );
                  }),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text(
            "Recommendations",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            "Top Picks",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(
              height: 195.0,
              child: ListView.separated(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (context, _) => const SizedBox(width: 12,),
              itemBuilder: (BuildContext context, int index) =>  buildCard(item: items[index], ),
           ),
          ),

        ],
      ),
    );
  }
  Widget buildCard({required SearchCards item}) => Container(
    width: 150,
    child: Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 4/3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                item.url,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          item.storyTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          item.author,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
