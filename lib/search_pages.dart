import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destudio_test/searchBox.dart';
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
      body: ListView(
        children: [
        Container(
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: SingleChildScrollView(//TODO: Does not make it scroll have to figure this out
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Search",
                  style:  TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                SearchBox(),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Genres",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SearchCards(),
                SearchCards(),
                SearchCards(),
                SearchCards(),
                SearchCards(),
                SearchCards(),
              ],
            ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}



//Scaffold(
//         appBar: AppBar(
//           title: const Text('Search'),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: searchController,
//                   decoration: const InputDecoration(labelText: 'Search'),
//                   onChanged: (val) {
//                     setState(() {
//                       storyName = val;
//                     });
//                   },
//                 ),
//
//                 Container(
//                   height: 200,
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance.collection('Stories').snapshots(),
//                     builder: (context,snapshots) {
//                       return(snapshots.connectionState == ConnectionState.waiting)? Center(child: CircularProgressIndicator(),)
//                           : ListView.builder(
//                         itemCount: snapshots.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;
//
//                           if (storyName.isEmpty){
//                             return Container();
//                           }
//
//                           if (data['storyName'].toString().trim().toLowerCase().startsWith(storyName.trim().toLowerCase())){
//                             return ListTile( //TODO: add support for tapping
//                               title: Text(data['storyName'], maxLines: 1, overflow: TextOverflow.ellipsis,),
//                               subtitle: Text(data['description'],maxLines: 1,overflow: TextOverflow.ellipsis,),
//                             );
//                           }
//                           return Container();
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//     );

