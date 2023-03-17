import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'userClasses.dart';

//https://www.youtube.com/watch?v=MB3YGQ-O1lk

class PlayStoryPage extends StatefulWidget {
  final String art; //image url
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
  //NOTE: Call these with widget.variable name
  final String art; //image url
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
      appBar: AppBar( //app bar is needed for back buttion
        title: const Text('Story'), //title of page - potentially change to story name
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getAuthorItems(),// this gets the information about the author of the story - investigate better ways to do it
          builder: (BuildContext context, AsyncSnapshot<AppUser> authorInfo) {
            if (authorInfo.connectionState == ConnectionState.waiting) { //if waiting for author information
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (authorInfo.hasError || !authorInfo.hasData) { //if there is an error
                return const Center(
                  child: Text('An Error Occurred'),
                );
              } else { //no error
                //Text(authorInfo.data!.userID)
                return Column( //correct information is returned
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox( //note: these are spacers
                      height: 15,
                    ),
                    //TODO: Fix Alignment
                    Row( //this si for top menu
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          child: Text(widget.storyName),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: bottomMenu, //this is called when tapped
                            child: const Icon(
                              Icons.more_horiz,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center( //story image
                      child: Image.network(
                        widget.art,
                        width: 250, //can change for sizing - maybe dynamic sizing
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //TODO: adjust row for things
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(//author image
                          authorInfo.data!.imageURL,
                          width: 50,
                        ),
                        Text( //author name - switch to username?
                          authorInfo.data!.firstName,
                          style: const TextStyle(
                              fontSize: 20, overflow: TextOverflow.ellipsis),
                        ),
                        IconButton( //this play button routes user to play page
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayAudioStoryPage( //for some reason this is necessary - investigate better ways to do it
                                            art: widget.art,
                                            authorID: widget.authorID,
                                            description: widget.description,
                                            downloadURL: widget.downloadURL,
                                            series: widget.series,
                                            seriesID: widget.seriesID,
                                            storyID: widget.storyID,
                                            storyName: widget.storyName,
                                            tags: widget.tags,
                                            firstName:
                                                authorInfo.data!.firstName,
                                            imageURL: authorInfo.data!.imageURL,
                                            lastName: authorInfo.data!.lastName,
                                            userID: authorInfo.data!.userID,
                                          )));
                            },
                            icon: const Icon(Icons.play_circle_fill_outlined))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(//descrption of story
                      width: 250,
                      child: Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('Tags'),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      margin: const EdgeInsets.all(16),
                      height: 80,
                      child: ListView.builder( //allows for scrolling of tags if there are many - guaranteed to be at least one
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.tags.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == widget.tags.length - 1) { //determines whether tag is last
                            return Text('${widget.tags[index]}'); //if last one, no comma
                          }
                          return Text('${widget.tags[index]},     '); //space and comma for not last
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

  //https://stackoverflow.com/questions/54188895/how-to-implement-a-bottom-navigation-drawer-in-flutter

  void bottomMenu() { //this is for the more context info
    //TODO: Add functionality - future builder?
    showModalBottomSheet( //this allows it to partially take screen over
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(widget.storyName),
                const SizedBox(
                  height: 15,
                ),
                Container(// note all items are like this - thus only this will be commented
                  padding: const EdgeInsets.all(16),
                  child: Row( //adds text and thumbs up  need to add functionality
                    //TODO: On pressed?
                    children: const [
                      Icon(Icons.thumb_up_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Like'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed?
                    children: const [
                      Icon(Icons.thumb_down_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Dislike'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed?
                    children: const [
                      Icon(Icons.bookmark_border),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Add to Listen Later'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed?
                    children: const[
                      Icon(Icons.add_to_photos_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Add to Playlist'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed? - double check whats there
                    children: const [
                      Icon(Icons.share),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Share'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed?
                    children: const [
                      Icon(Icons.read_more_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('View Story Description'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed?
                    children: const [
                      Icon(Icons.account_circle_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('View Author Profile'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed?
                    children: const [
                      Icon(Icons.transcribe_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('View Transcript'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    //TODO: On pressed?
                    children: const [
                      Icon(Icons.report_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Report'),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<AppUser> getAuthorItems() async { //this gets and returns the author information for a story
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.authorID) //get specific doc matching the story author information
        .get();
    final DocumentSnapshot document = result; //for some reason this is necessary to make it function correctly
    final tempUser = AppUser( //generates appuser class - returns
        userID: document['userID'],
        firstName: document['firstName'],
        lastName: document['lastName'],
        imageURL: document['imageURL']);

    return tempUser; //returns appuser
  }
}

class PlayAudioStoryPage extends StatefulWidget { //actual audio player
  //Story variables
  final String art; //for story image
  final String authorID;
  final String description;
  final String downloadURL;
  final String series;
  final String seriesID;
  final String storyID;
  final String storyName;
  final List<dynamic> tags;

  //Author variables
  final String firstName;
  final String imageURL;
  final String lastName;
  final String userID;

  const PlayAudioStoryPage({
    Key? key,
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
    //same as test page - see 'play_audio.dart'
    //https://www.youtube.com/watch?v=MB3YGQ-O1lk
    super.initState();

    setAudio();

    if (mounted) {
      audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state == PlayerState.playing;
          });
        }
      });
    }

    if (mounted) {
      audioPlayer.onDurationChanged.listen((newDuration) {
        if (mounted) {
          setState(() {
            duration = newDuration;
          });
        }
      });
    }

    if (mounted) {
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
            const SizedBox(
              height: 15,
            ),
            Center(
                child: Image.network(
              widget.art, //For story image
              width: 250,
            )),
            const SizedBox(
              height: 15,
            ),
            Text(widget.storyName),
            const SizedBox(
              height: 15,
            ),
            Row( //author information
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  widget.imageURL,
                  width: 75,
                ),
                Text(widget.firstName),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Slider( //audio time slider
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
              },
            ),
            Padding(//times
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              ),
            ),
            CircleAvatar( //play/pause
              radius: 35,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying) { //pauses or plays
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

  String formatTime(Duration duration) { //utility for displaying formatted time (https://www.youtube.com/watch?v=MB3YGQ-O1lk)
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future setAudio() async { //sets audio so that it does not load each time play is pressed/ audio plays
    audioPlayer.setReleaseMode(ReleaseMode.release);

    audioPlayer.setSourceUrl(widget.downloadURL);
  }
}
