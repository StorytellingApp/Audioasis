import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destudio_test/main.dart';
import 'package:destudio_test/userClasses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

//https://www.youtube.com/watch?v=Jt3OSCe7eOw
//https://pub.dev/packages/file_picker
//https://github.com/miguelpruivo/flutter_file_picker/wiki/API#filters

enum UploadType { single, chapter } //No longer used for single upload

enum ChapterFirstOrNot { firstChapter, notFirstChapter } // Was for determining what position in series

const List<String> uploadDropOptions = ['Single', 'Series']; //for old dropdown menu
const List<String> seriesDropOptions = ['Yes', 'No']; //for old dropdown menu

class UploadTabPage extends StatefulWidget {
  const UploadTabPage({Key? key}) : super(key: key);

  @override
  State<UploadTabPage> createState() => _UploadTabPageState();
}

class _UploadTabPageState extends State<UploadTabPage> {
  PlatformFile? pickedImage; //the image that is selected
  PlatformFile? pickedAudio; //the audio that is selected

  PlatformFile? seriesPickedImage; //no longer used
  PlatformFile? seriesFirstPickedAudio; //no longer used
  PlatformFile? seriesLaterPickedAudio; //no longer used

  UploadTask? imageUploadTask; //for keeping track of upload tasks
  UploadTask? audioUploadTask; //for keeping track of upload tasks

  //For the selected series
  //var selectedSeries = '';

  UploadType? _uploadType = UploadType.single;
  String _stringUpload = uploadDropOptions.first;
  String _seriesType = seriesDropOptions.first; //was for dropdown menu

  String _series = 'Test';

  final singleFormKey = GlobalKey<FormState>(); //for single chapter upload form verification
  final chapterFormKey = GlobalKey<FormState>();

  //text controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagController = TextEditingController();

  final seriesTitleController = TextEditingController();
  final seriesDescriptionController = TextEditingController();
  final seriesTagController = TextEditingController();

  final seriesNameController = TextEditingController();

  @override
  void dispose() {
    //for disposing text controllers
    titleController.dispose();
    descriptionController.dispose();
    tagController.dispose();

    seriesTitleController.dispose();
    seriesDescriptionController.dispose();
    seriesTagController.dispose();
    seriesNameController.dispose();

    super.dispose();
  }

  Future uploadAllSingle() async { //this uploads the story, and is what is actually called
    //Check if image and audio are not null and validates form - all fields are filled
    final isValid = singleFormKey.currentState!.validate();
    if (!isValid) return;
    if (pickedImage == null) {
      Utils.showSnackBar('Please Select an Image');
      return;
    }
    if (pickedAudio == null) {
      Utils.showSnackBar('Please Select an Audio File');
      return;
    }

    //Entire Form is Filled Out
    //https://www.reddit.com/r/Firebase/comments/tzwtzu/should_image_names_be_unique_when_storing_in/

    //shows circularprogressindicator while upload takes place
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    //generates unique story and image ids for files
    final storyID =
        '${FirebaseAuth.instance.currentUser!.uid.toString()}audio${DateTime.now().toString()}';
    final imageID =
        '${FirebaseAuth.instance.currentUser!.uid.toString()}image${DateTime.now().toString()}';
    print(storyID);
    //Unique story ID

    //Put image and audio up - keep track of download URLS
    //creates file objects for selected files
    final imagePath = 'StoryImages/$imageID';
    final imageFile = File(pickedImage!.path!);
    final audioPath = 'Audio/$storyID';
    final audioFile = File(pickedAudio!.path!);

    //uploads audio to firebase
    final audioRef = FirebaseStorage.instance.ref().child(audioPath);
    audioUploadTask = audioRef.putFile(audioFile);
    final audioSnapshot = await audioUploadTask!.whenComplete(() => {}); //waits until upload task is complete
    final audioURL = await audioSnapshot.ref.getDownloadURL(); //gets download url of audio
    print(audioURL);

    //uploads image to firebase
    final imageRef = FirebaseStorage.instance.ref().child(imagePath);
    imageUploadTask = imageRef.putFile(imageFile);
    final imageSnapshot = await imageUploadTask!.whenComplete(() => {}); //waits until upload task is complete
    final imageURL = await imageSnapshot.ref.getDownloadURL(); //gets download url of image
    print(imageURL);

    //Parse tags
    List<String> tagList = [];

    final parsedTags = tagController.text.split(',');
    //Trim each thing and lowercase
    //print(parsedTags);
    for (var i = 0; i < parsedTags.length; i++) {
      var tag = parsedTags[i].trim().toLowerCase();
      //print(tag);
      tagList.add(tag);
    }
    //print(tagList);

    //Prep for putting to firebase
    //creates story information object
    final uploadStoryFirebase = Story(
      storyID: storyID,
      storyName: titleController.text.trim(),
      downloadURL: audioURL,
      art: imageURL,
      authorID: FirebaseAuth.instance.currentUser!.uid,
      description: descriptionController.text.trim(),
      tags: tagList,
      series: false,
      seriesID: '',
    );
    //uploads story object to firestore
    final storyJsonUpload =
        FirebaseFirestore.instance.collection('Stories').doc(storyID);
    storyJsonUpload.set(uploadStoryFirebase.toJson());

    //clears circular progress indicator
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    setState(() { //clears upload page - needs some adjusting
      pickedImage = null;
      pickedAudio = null;
      titleController.clear();
      descriptionController.clear();
      tagController.clear();
    });

    //shows dialog saying story was succesfully uploaded
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Story Succesfully Uploaded'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Exit'))
              ],
            ));
  }

  Future uploadAllFirstSeries() async { //This follows the same process as above - NO LONGER USED
    final isValid = chapterFormKey.currentState!.validate(); //validates form, ensures images and audio files are selected
    if (!isValid) return;
    if (pickedImage == null) {
      Utils.showSnackBar('Please Select an Image');
      return;
    }
    if (pickedAudio == null) {
      Utils.showSnackBar('Please Select an Audio File');
      return;
    }

    //Entire form is filled out
    final storyID =
        '${FirebaseAuth.instance.currentUser!.uid.toString()}audio${DateTime.now().toString()}';
    final imageID =
        '${FirebaseAuth.instance.currentUser!.uid.toString()}image${DateTime.now().toString()}';

    final imagePath = 'StoryImages/$imageID';
    final imageFile = File(pickedImage!.path!);
    final audioPath = 'Audio/$storyID';
    final audioFile = File(pickedAudio!.path!);

    final audioRef = FirebaseStorage.instance.ref().child(audioPath);
    audioUploadTask = audioRef.putFile(audioFile);
    final audioSnapshot = await audioUploadTask!.whenComplete(() => null);
    final audioURL = await audioSnapshot.ref.getDownloadURL();
    print(audioURL);

    final imageRef = FirebaseStorage.instance.ref().child(imagePath);
    imageUploadTask = imageRef.putFile(imageFile);
    final imageSnapshot = await imageUploadTask!.whenComplete(() => null);
    final imageURL = await imageSnapshot.ref.getDownloadURL();
    print(imageURL);

    //parse tags
    List<String> tagList = [];

    final parsedTags = seriesTagController.text.split(',');
    for (var i = 0; i < parsedTags.length; i++) {
      var tag = parsedTags[i].trim().toLowerCase();
      tagList.add(tag);
    }

    final seriesID =
        '${FirebaseAuth.instance.currentUser!.uid.toString()}series${DateTime.now().toString()}';

    //prep for putting to firebase - both playlist and story
    List<String> stories = [storyID]; //Creates series information
    final uploadSeries = Series(
      seriesID: seriesID,
      authorID: FirebaseAuth.instance.currentUser!.uid.toString(),
      stories: stories,
      seriesName: seriesTitleController.text.trim(),
    );

    final uploadStory = Story(
      storyID: storyID,
      storyName: seriesTitleController.text.trim(),
      downloadURL: audioURL,
      art: imageURL,
      authorID: FirebaseAuth.instance.currentUser!.uid,
      description: seriesDescriptionController.text.trim(),
      tags: tagList,
      series: true,
      seriesID: seriesID,
    );

    final storyJsonUpload =
        FirebaseFirestore.instance.collection('Stories').doc(storyID);
    storyJsonUpload.set(uploadStory.toJson());

    final seriesJsonUpload =
        FirebaseFirestore.instance.collection('Series').doc(seriesID);
    seriesJsonUpload.set(uploadSeries.toJson());
  }

  Future pickImage() async { //picks image
    final userImage = await FilePicker.platform.pickFiles(type: FileType.image);
    if (userImage == null) return;

    setState(() { //sets variable to image
      pickedImage = userImage.files.first;
    });
  }

  Future pickAudio() async { //picks audio
    final userAudio = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3', 'wav']);
    if (userAudio == null) return;

    setState(() { //sets variable to image
      pickedAudio = userAudio.files.first;
    });
  }

  Widget firstChapter() { //No longer used - creates form for uploading
    return Form(
      key: chapterFormKey, //for form validation
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16), //series name field
            child: TextFormField(
              controller: seriesNameController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Series Name'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isEmpty ? 'Enter a Series Name' : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField( //chapter name field
              controller: seriesTitleController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Chapter Name'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isEmpty ? 'Enter a Name' : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField( //description field
              controller: seriesDescriptionController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Story Description'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isEmpty ? 'Enter a Description' : null,
            ),
          ),
          if (pickedAudio != null) //if audio IS chosen, display that the audio is selected
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Audio Chosen'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          Row( //button for audio selection
            children: [
              const Spacer(
                flex: 1,
              ),
              ElevatedButton(
                  onPressed: pickAudio,
                  child: Row(
                    children: const [
                      Text('Upload Audio '),
                      Icon(Icons.upload),
                    ],
                  )),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
          Container( //field for tags
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: seriesTagController,
              textInputAction: TextInputAction.done,
              decoration:
                  const InputDecoration(labelText: 'Tags (Comma Separated)'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isEmpty ? 'Enter Tags' : null, //validation
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton( //for uploading
            onPressed: uploadAllFirstSeries, //TODO: Do form validation
            child: const Text('Publish Story'),
          ),
        ],
      ),
    );
  }

  Widget laterChapter() { //NOT USED - had trouble listing previously uploaded series
    String _dropDownSeries = '';
//https://stackoverflow.com/questions/49764905/how-to-assign-future-to-widget-in-flutter
    //https://stackoverflow.com/questions/56249715/futurebuilder-doesnt-wait-for-future-to-complete
    List<String> initialDataStuff = [];
    return FutureBuilder(
      future: getItems(),
      initialData: initialDataStuff,
      builder:
          (BuildContext context, AsyncSnapshot<List<String>> authorSeries) {
        if (authorSeries.hasData && !authorSeries.hasError) {
          if (authorSeries.data!.isEmpty) {
            return const Text('No Series Found');
            //Either loading data or none found
          } else {
            //TODO: Do rest of upload page here - dropdown menu as well
            //TODO: Now, only replace thing when name == what is selected - another futurebuilder to get the data?

            _dropDownSeries = authorSeries.data!.first;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text(authorSeries.data!.first.toString()),
                DropdownButton<String>(
                  value: _dropDownSeries,
                  isExpanded:
                      true, //https://stackoverflow.com/questions/54069869/how-to-solve-a-renderflex-overflowed-by-143-pixels-on-the-right-error-in-text
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _dropDownSeries = value!;
                    });
                  },
                  items: authorSeries.data!
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      //https://stackoverflow.com/questions/51930754/flutter-wrapping-text
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(value, overflow: TextOverflow.ellipsis),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<String>> getItems() async { //this was used in order to get the information regarding the current user - not used
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Series')
        .where('authorID',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    List<String> authorSeries = [];
    documents.forEach((element) {
      authorSeries.add(element['seriesName']);
    });
    print(authorSeries);
    //Correctly gets the stuff - check if empty - say only no series found

    return authorSeries;

    //TODO: build list
  }

  Widget singleStory() { //THIS IS USED - Main Upload page
    return Form(
      key: singleFormKey, //for form validation
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField( //title field
              controller: titleController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Title'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isEmpty ? 'Enter a Name' : null, //validation
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField( //description field
              controller: descriptionController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Description'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isEmpty ? 'Enter a Description' : null, //validation
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Audio: Upload mp3 or WAV'),
          const SizedBox(
            height: 15,
          ),
          if (pickedAudio != null) //only display if audio is chosen
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Audio Chosen'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          Row(
            children: [
              const Spacer(
                flex: 1,
              ),
              ElevatedButton(
                  onPressed: pickAudio, //for picking audio
                  child: Row(
                    children: const [
                      Text('Upload Audio '),
                      Icon(Icons.upload),
                    ],
                  )),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
          Container( //for tags
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: tagController,
              textInputAction: TextInputAction.done,
              decoration:
                  const InputDecoration(labelText: 'Tags (Comma Separated)'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isEmpty ? 'Enter Tags' : null,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: uploadAllSingle, //calls the upload function
            child: const Text('Publish Story'),
          ),
        ],
      ),
    );
  }

  Widget chapterStory() { //NOT USED
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('First Chapter'),
            const SizedBox(
              width: 25,
            ),
            DropdownButton<String>(
              value: _seriesType,
              elevation: 16,
              underline: Container(
                height: 2,
              ),
              onChanged: (String? value) {
                setState(() {
                  _seriesType = value!;
                });
              },
              items: seriesDropOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        (_seriesType == 'Yes') ? firstChapter() : laterChapter(),
      ],
    );
  }

  @override //THis is what is displayed initially
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              (pickedImage == null) //displays no image found if no image selected, else display image
                  ? Image.asset(
                      'images/NoImageDefault.jpg',
                      fit: BoxFit.fitWidth,
                      height: 250,
                    )
                  : Image.file(
                      File(pickedImage!.path!),
                      fit: BoxFit.fitWidth,
                      height: 250,
                    ),
              ElevatedButton( //picks images
                  onPressed: pickImage, //TODO: Fix image sizing and whatnot
                  child: (pickedImage == null) //varies text based on input
                      ? const Text('Pick an Image')
                      : const Text('Choose Another Image')),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              singleStory(),
            ],
          ),
        ),
      ),
    );
  }
}

//No longer used - can use for reference
/*
class UploadAudio extends StatefulWidget {
  const UploadAudio({Key? key}) : super(key: key);

  @override
  State<UploadAudio> createState() => _UploadAudioState();
}

class _UploadAudioState extends State<UploadAudio> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future uploadFile() async {
    final path = 'Audio/${pickedFile!.name}'; //TODO: Unique name
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    //TODO: Progress bar?
    //TODO: add auto route or something after upload?
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Audio'),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (pickedFile != null) Text(pickedFile!.name),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: selectFile,
              child: const Text('Select File'),
            ),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: uploadFile,
              child: const Text('Upload File'),
            ),
          ],
        ),
      )),
    );
  }
}

*/

/*
return Form(
      key: chapterFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: seriesTitleController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Title'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                value != null && value.isEmpty ? 'Enter a Name' : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: seriesDescriptionController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Description'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                value != null && value.isEmpty ? 'Enter a Description' : null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Audio: Upload mp3 or WAV'),
          if (seriesPickedAudio != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Audio Chosen'),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
        ],
      ),
    );
 */
