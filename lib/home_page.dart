import 'package:destudio_test/library_pages.dart';
import 'package:destudio_test/upload_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'search_pages.dart';
import 'main_home_page.dart';

//https://stackoverflow.com/questions/46891916/flutter-change-main-appbar-title-on-other-pages

//Main Tab View

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //gets currently signed in user
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea( //TODO: adjust safearea widget
      //Creates 4 Tabs
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          bottomNavigationBar: Material(
            color: Theme.of(context).colorScheme.primary,
            child: const TabBar(
              tabs: <Widget>[
                //These contain the icons that are used on the bottom navigation bar
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.file_upload_outlined),
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
              //These are the pages that are put on the screen
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


//Old homepage - used during testing
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
