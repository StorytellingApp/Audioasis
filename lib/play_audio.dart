import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

//References:
//https://www.youtube.com/watch?v=MB3YGQ-O1lk

//This page is no longer used - was to test playing audio from Firebase

class PlayAudioWidget extends StatefulWidget {
  const PlayAudioWidget({Key? key}) : super(key: key);

  @override
  State<PlayAudioWidget> createState() => _PlayAudioWidgetState();
}

class _PlayAudioWidgetState extends State<PlayAudioWidget> {
  final storageRef = FirebaseStorage.instance.ref();

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    //play, pause, etc
    if (mounted){
      audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state == PlayerState.playing;
          });
        }

      });
    }


    //duration
    if (mounted){
      audioPlayer.onDurationChanged.listen((newDuration) {
        if (mounted) {
          setState(() {
            duration = newDuration;
          });
        }

      });
    }


    //audio position
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
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  //initializes audio player
  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.release);

    //This audio no longer exists
    String storyURL = await storageRef.child("Audio/Test2.mp3").getDownloadURL();
    audioPlayer.setSource(UrlSource(storyURL));
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play audio'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Test Audio',
            style: TextStyle(fontSize: 14),
          ),
          //position indicator
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration-position)),
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
    );
  }

  //utility for displaying time
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
}
