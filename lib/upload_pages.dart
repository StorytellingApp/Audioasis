import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destudio_test/userClasses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'utils.dart';
import 'verify_email_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

//https://www.youtube.com/watch?v=Jt3OSCe7eOw
//https://pub.dev/packages/file_picker
//https://github.com/miguelpruivo/flutter_file_picker/wiki/API#filters

enum UploadType { single, chapter }

enum ChapterFirstOrNot { firstChapter, notFirstChapter }

const List<String> uploadDropOptions = ['Single', 'Series'];
const List<String> seriesDropOptions = ['Yes', 'No'];

class UploadTabPage extends StatefulWidget {
  const UploadTabPage({Key? key}) : super(key: key);

  @override
  State<UploadTabPage> createState() => _UploadTabPageState();
}

class _UploadTabPageState extends State<UploadTabPage> {
  PlatformFile? pickedImage;
  PlatformFile? pickedAudio;

  PlatformFile? seriesPickedImage;
  PlatformFile? seriesFirstPickedAudio;
  PlatformFile? seriesLaterPickedAudio;

  UploadTask? imageUploadTask;
  UploadTask? audioUploadTask;

  //For the selected series
  //var selectedSeries = '';

  UploadType? _uploadType = UploadType.single;
  String _stringUpload = uploadDropOptions.first;
  String _seriesType = seriesDropOptions.first;

  String _series = 'Test';

  final singleFormKey = GlobalKey<FormState>();
  final chapterFormKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagController = TextEditingController();

  final seriesTitleController = TextEditingController();
  final seriesDescriptionController = TextEditingController();
  final seriesTagController = TextEditingController();

  final seriesNameController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    tagController.dispose();

    seriesTitleController.dispose();
    seriesDescriptionController.dispose();
    seriesTagController.dispose();
    seriesNameController.dispose();

    super.dispose();
  }

  Future uploadAllSingle() async {
    //Check if image and audio are not null
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
    final storyID =
        '${FirebaseAuth.instance.currentUser!.uid!.toString()}audio${DateTime.now().toString()}';
    final imageID =
        '${FirebaseAuth.instance.currentUser!.uid!.toString()}image${DateTime.now().toString()}';
    print(storyID);
    //Unique story ID

    //Put image and audio up - keep track of download URLS
    final imagePath = 'StoryImages/$imageID';
    final imageFile = File(pickedImage!.path!);
    final audioPath = 'Audio/$storyID';
    final audioFile = File(pickedAudio!.path!);

    final audioRef = FirebaseStorage.instance.ref().child(audioPath);
    audioUploadTask = audioRef.putFile(audioFile);
    final audioSnapshot = await audioUploadTask!.whenComplete(() => {});
    final audioURL = await audioSnapshot.ref.getDownloadURL();
    print(audioURL);

    final imageRef = FirebaseStorage.instance.ref().child(imagePath);
    imageUploadTask = imageRef.putFile(imageFile);
    final imageSnapshot = await imageUploadTask!.whenComplete(() => {});
    final imageURL = await imageSnapshot.ref.getDownloadURL();
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
    final storyJsonUpload =
    FirebaseFirestore.instance.collection('Stories').doc(storyID);
    storyJsonUpload.set(uploadStoryFirebase.toJson());
  }

  Future uploadAllFirstSeries() async {
    final isValid = chapterFormKey.currentState!.validate();
    if (!isValid) return;
    if (pickedImage == null) {
      Utils.showSnackBar('Please Select an Image');
      return;
    }
    if (pickedAudio == null) {
      Utils.showSnackBar('Please Select an Audio File');
      return;
    }

    //Enitre form is filled out
    final storyID =
        '${FirebaseAuth.instance.currentUser!.uid!.toString()}audio${DateTime.now().toString()}';
    final imageID =
        '${FirebaseAuth.instance.currentUser!.uid!.toString()}image${DateTime.now().toString()}';

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
        '${FirebaseAuth.instance.currentUser!.uid!.toString()}series${DateTime.now().toString()}';

    //prep for putting to firebase - both playlist and story
    List<String> stories = [storyID];
    final uploadSeries = Series(
      seriesID: seriesID,
      authorID: FirebaseAuth.instance.currentUser!.uid!.toString(),
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

  Future pickImage() async {
    final userImage = await FilePicker.platform.pickFiles(type: FileType.image);
    if (userImage == null) return;

    setState(() {
      pickedImage = userImage.files.first;
    });
  }

  Future pickAudio() async {
    final userAudio = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3', 'wav']);
    if (userAudio == null) return;

    setState(() {
      pickedAudio = userAudio.files.first;
    });
  }

  Widget firstChapter() {
    return Form(
      key: chapterFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
            child: TextFormField(
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
            child: TextFormField(
              controller: seriesDescriptionController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Story Description'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
              value != null && value.isEmpty ? 'Enter a Description' : null,
            ),
          ),
          if (pickedAudio != null)
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
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: seriesTagController,
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
            onPressed: uploadAllFirstSeries, //TODO: Do form validation
            child: const Text('Publish Story'),
          ),
        ],
      ),
    );
  }

  Widget laterChapter() {
    String _dropDownSeries = '';
//https://stackoverflow.com/questions/49764905/how-to-assign-future-to-widget-in-flutter
    //https://stackoverflow.com/questions/56249715/futurebuilder-doesnt-wait-for-future-to-complete
    List<String> initialDataStuff = [];
    return FutureBuilder(
      future: getItems(),
      initialData: initialDataStuff,
      builder: (BuildContext context, AsyncSnapshot<List<String>> authorSeries) {
        if (authorSeries.hasData && !authorSeries.hasError) {
          if (authorSeries.data!.isEmpty){
            return const Text('No Series Found');
            //Either loading data or none found
          }else{
            //TODO: Do rest of upload page here - dropdown menu as well
            //TODO: Now, only replace thing when name == what is selected - another futurebuilder to get the data?

            _dropDownSeries = authorSeries.data!.first;


            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text(authorSeries.data!.first.toString()),
                DropdownButton<String>(
                  value: _dropDownSeries,
                  isExpanded: true, //https://stackoverflow.com/questions/54069869/how-to-solve-a-renderflex-overflowed-by-143-pixels-on-the-right-error-in-text
                  elevation: 16,
                  underline: Container(height: 2,),
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
                        child: Text(value,overflow: TextOverflow.ellipsis),
                      ),


                    );
                  }).toList(),
                ),
              ],
            );
          }
        }else{
          return const Center(child: CircularProgressIndicator(),);
        }

      },
    );
  }

  Future<List<String>> getItems() async {
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

  Widget singleStory() {
    return Form(
      key: singleFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: titleController,
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
              controller: descriptionController,
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
          const SizedBox(
            height: 15,
          ),
          if (pickedAudio != null)
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
          Container(
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
            onPressed: uploadAllSingle, //TODO: Do form validation
            child: const Text('Publish Story'),
          ),
        ],
      ),
    );
  }

  Widget chapterStory() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //TODO: add form validation
              const SizedBox(
                height: 10,
              ),
              (pickedImage == null)
                  ? Image.asset(
                'images/NoImageDefault.jpg', //TODO: DOes not load
                fit: BoxFit.fitWidth,
                height: 250,
              )
                  : Image.file(
                File(pickedImage!.path!),
                fit: BoxFit.fitWidth,
                height: 250,
              ),
              ElevatedButton(
                  onPressed: pickImage, //TODO: Fix image sizing and whatnot
                  child: (pickedImage == null)
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
