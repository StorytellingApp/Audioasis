import 'package:destudio_test/library_pages.dart';
import 'package:destudio_test/upload_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'play_audio.dart';
import 'firestore_test_page.dart';
import 'firestore_read_test.dart';
import 'search_pages.dart';
import 'upload_pages.dart';
import 'search_pages.dart';
import 'main_home_page.dart';

//https://stackoverflow.com/questions/46891916/flutter-change-main-appbar-title-on-other-pages

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea( //TODO: adjust safearea widget
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          /*
        appBar: AppBar(
          title: const Text('1'),
        ),*/
          bottomNavigationBar: Material(
            color: Theme.of(context).colorScheme.primary,
            child: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.add_circle_outline),
                ),
                Tab(
                  icon: Icon(Icons.book),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //TODO: Pages go here
              HomeTabPage(),
              SearchTabPage(),
              UploadTabPage(),
              LibraryTabPage(),
            ],
          ),
        ),
      ),
    );
  }
}

/*
Scaffold(
      appBar: AppBar(
        title: const Text('Logged In'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Logged in as')
          ),
          Center(
            child: Text(
              user.email!,
            ),
          ),
          TextButton(onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Logout')
          ),
          const SizedBox(height: 25,),
          TextButton(
            onPressed: () => Navigator.push(context,MaterialPageRoute(
              builder: (context) => const PlayAudioWidget()
            )),
            child: const Text('Go To Audio Player'),
          ),
          const SizedBox(height: 25,),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const FirePageTest()
            )),
            child: const Text('Go To Firestore Write Page'),
          ),
          const SizedBox(height: 25,),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => const FirestoreWriteTest()
            )),
            child: const Text('Go To Firestore Read Page'),
          ),
          const SizedBox(height: 25,),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => const UploadAudio()
            )),
            child: const Text('Go To Upload Audio Page'),
          ),
        ],
      ),
    );
 */
