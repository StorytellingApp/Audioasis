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

enum UploadType {single, chapter}
const List<String> uploadDropOptions = ['Single','Series'];




class UploadTabPage extends StatefulWidget {
  const UploadTabPage({Key? key}) : super(key: key);

  @override
  State<UploadTabPage> createState() => _UploadTabPageState();
}

class _UploadTabPageState extends State<UploadTabPage> {
  PlatformFile? pickedImage;
  UploadTask? imageUploadTask;
  UploadType? _uploadType = UploadType.single;
  String _stringUpload = uploadDropOptions.first;


  Future pickImage() async {
    final userImage = await FilePicker.platform.pickFiles(type: FileType.image);
    if (userImage == null) return;

    setState(() {
      pickedImage = userImage.files.first;
    });
  }

  Widget singleStory() {
    return Column(
      children: [
        const Text('Single'),
      ],
    );
  }

  Widget chapterStory() {
    return Column(
      children: [
        const Text('Chapter'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //TODO: add form validation
              const SizedBox(height: 10,),
              (pickedImage == null) ? const SizedBox(height: 250,child: Text('No Image Selected'),) : Image.file(File(pickedImage!.path!),fit: BoxFit.fitWidth,height: 250,),
              ElevatedButton(onPressed: pickImage, //TODO: Fix image sizing and whatnot
                child: (pickedImage == null) ? const Text('Pick an Image') : const Text('Choose Another Image')
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Story Type'),
                  SizedBox(width: 25,),
                  DropdownButton<String>(
                    value: _stringUpload,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _stringUpload = value!;
                      });
                    },
                    items: uploadDropOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              (_stringUpload == 'Single') ? singleStory() : chapterStory(),
            ],
          ),
        ),
      ),
    );
  }
}













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

  Future selectFile() async{
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
              const SizedBox(height: 10,),
              if (pickedFile != null) Text(pickedFile!.name),
              const SizedBox(height: 25,),
              TextButton(
                onPressed: selectFile,
                child: const Text('Select File'),
              ),
              const SizedBox(height: 25,),
              TextButton(
                onPressed: uploadFile,
                child: const Text('Upload File'),
              ),
            ],
          ),
        )
      ),
    );
  }
}
