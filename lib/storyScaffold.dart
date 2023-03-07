import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'userClasses.dart';

//https://www.youtube.com/watch?v=MB3YGQ-O1lk

class PlayStoryPage extends StatefulWidget {
  final String art;
  final String authorID;
  final String description;
  final String downloadURL;
  final String series;
  final String seriesID;
  final String storyID;
  final String storyName;
  final List<dynamic> tags;

  const PlayStoryPage(
      {Key? key,
      required this.art,
      required this.authorID,
      required this.description,
      required this.downloadURL,
      required this.series,
      required this.seriesID,
      required this.storyID,
      required this.storyName,
      required this.tags})
      : super(key: key);

  @override
  State<PlayStoryPage> createState() => _PlayStoryPageState();
}

class _PlayStoryPageState extends State<PlayStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.storyName),
        ],
      ),
    );
  }
}

class DescriptionStoryPage extends StatefulWidget {
  final String art;
  final String authorID;
  final String description;
  final String downloadURL;
  final String series;
  final String seriesID;
  final String storyID;
  final String storyName;
  final List<dynamic> tags;

  const DescriptionStoryPage(
      {Key? key,
      required this.art,
      required this.authorID,
      required this.description,
      required this.downloadURL,
      required this.series,
      required this.seriesID,
      required this.storyID,
      required this.storyName,
      required this.tags})
      : super(key: key);

  @override
  State<DescriptionStoryPage> createState() => _DescriptionStoryPageState();
}

class _DescriptionStoryPageState extends State<DescriptionStoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getAuthorItems(),
          builder: (BuildContext context, AsyncSnapshot<AppUser> authorInfo) {
            if (authorInfo.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }else{
              if (authorInfo.hasError || !authorInfo.hasData) {
                return const Center(child: Text('An Error Occured'),);
              }else {
                //Text(authorInfo.data!.userID)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15,),
                    Text(widget.storyName),
                    const SizedBox(height: 15,),
                    Center(child: Image.network(widget.art, width: 250,),),
                    const SizedBox(height: 15,),
                    //TODO: adjust row for things
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Image.network(authorInfo.data!.imageURL, width: 50,),
                      Text(authorInfo.data!.firstName,style: const TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),),
                        IconButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayAudioStoryPage(
                            art: widget.art,
                            authorID: widget.authorID,
                            description: widget.description,
                            downloadURL: widget.downloadURL,
                            series: widget.series,
                            seriesID: widget.seriesID,
                            storyID: widget.storyID,
                            storyName: widget.storyName,
                            tags: widget.tags,
                            firstName: authorInfo.data!.firstName,
                            imageURL: authorInfo.data!.imageURL,
                            lastName: authorInfo.data!.lastName,
                            userID: authorInfo.data!.userID,
                          )));
                        },
                            icon: const Icon(Icons.play_circle_fill_outlined))
                    ],
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(width: 250,
                    child: Text(widget.description, style: const TextStyle(
                      fontSize: 18,
                    ),),),
                    const SizedBox(height: 30,),
                    const Text('Tags'),
                    const SizedBox(height: 10,),

                    Container(
                      margin: const EdgeInsets.all(16),
                      height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.tags.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == widget.tags.length - 1){
                          return Text('${widget.tags[index]}');
                        }
                        return Text('${widget.tags[index]},     ');
                      },
                    ),
                    ),

                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<AppUser> getAuthorItems() async {
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get();
    final DocumentSnapshot document = result;
    final tempUser = AppUser(userID: document['userID'],
        firstName: document['firstName'],
        lastName: document['lastName'],
        imageURL: document['imageURL']);



    return tempUser;
  }
}

class PlayAudioStoryPage extends StatefulWidget {
  final String art;
  final String authorID;
  final String description;
  final String downloadURL;
  final String series;
  final String seriesID;
  final String storyID;
  final String storyName;
  final List<dynamic> tags;

  final String firstName;
  final String imageURL;
  final String lastName;
  final String userID;


  const PlayAudioStoryPage({Key? key,
    required this.art,
    required this.authorID,
    required this.description,
    required this.downloadURL,
    required this.series,
    required this.seriesID,
    required this.storyID,
    required this.storyName,
    required this.tags,
    required this.firstName,
    required this.imageURL,
    required this.lastName,
    required this.userID,
  }) : super(key: key);
  //TODO: pass in all information via parameters

  @override
  State<PlayAudioStoryPage> createState() => _PlayAudioStoryPageState();
}

class _PlayAudioStoryPageState extends State<PlayAudioStoryPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    if (mounted){
      audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state == PlayerState.playing;
          });
        }
      });
    }


    if (mounted){
      audioPlayer.onDurationChanged.listen((newDuration) {
        if (mounted) {
          setState(() {
            duration = newDuration;
          });
        }

      });
    }


    if (mounted){
      audioPlayer.onPositionChanged.listen((newPosition) {
        if (mounted) {
          setState(() {
            position = newPosition;
          });
        }
      });
    }

  }


  @override
  dispose() {
    audioPlayer.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Story'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Center(child: Image.network(widget.art, width: 250,)),
            const SizedBox(height: 15,),
            Text(widget.storyName),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(widget.imageURL,width: 75,),
                Text(widget.firstName),
              ],
            ),
            const SizedBox(height: 25,),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                },
            ),
            Padding(padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration)),
              ],
            ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.release);

    audioPlayer.setSourceUrl(widget.downloadURL);

  }
}

