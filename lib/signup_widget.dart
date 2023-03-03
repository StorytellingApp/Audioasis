import 'dart:io';

import 'package:destudio_test/userClasses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'utils.dart';
import 'package:file_picker/file_picker.dart';


//References:
//https://www.youtube.com/watch?v=4vKiJZNPhss

class SignUpWidget extends StatefulWidget {
  final VoidCallback onCLickedSignUp;
  const SignUpWidget({Key? key, required this.onCLickedSignUp})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  PlatformFile? pickedImage;
  UploadTask? imageUploadTask;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  Future pickImage() async {
    final userImage = await FilePicker.platform.pickFiles(type: FileType.image);
    if (userImage == null) return;

    setState(() {
      pickedImage = userImage.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(height: 15,),
                    ElevatedButton(
                        onPressed: pickImage, //TODO: Fix image sizing and whatnot
                        child: (pickedImage == null)
                            ? const Text('Pick an Image')
                            : const Text('Choose Another Image')),
                    const SizedBox(height: 15,),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(


                        controller: userNameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Email'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter 6 characters minimum'
                            : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value != null && value.isEmpty ? 'Enter a Name' : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        controller: lastNameController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value != null && value.isEmpty ? 'Enter a Name' : null,
                      ),
                    ),
                    TextButton(
                      onPressed: signIn,
                      child: const Text('Sign Up'),
                    ),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          text: 'Already have an account?   ',
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.onCLickedSignUp,
                                text: 'Log In',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.secondary,
                                ))
                          ]),
                    )
                  ],
                ),
              )),
          ),
        ),
      );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (pickedImage == null) {
      Utils.showSnackBar('Please Select an Image');
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );

      //Added for creating user info
      final userID = FirebaseAuth.instance.currentUser!.uid;
      print(userID);

      //TODO: upload Image
      final userImageID = '${FirebaseAuth.instance.currentUser!.uid!.toString()}userImage${DateTime.now().toString()}';
      final imagePath = 'UserImages/$userImageID';
      final imageFile = File(pickedImage!.path!);
      final imageRef = FirebaseStorage.instance.ref().child(imagePath);
      imageUploadTask = imageRef.putFile(imageFile);
      final imageSnapshot = await imageUploadTask!.whenComplete(() => {});
      final imageURL = await imageSnapshot.ref.getDownloadURL();
      print(imageURL);



      final test = AppUser(
          userID: userID,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          imageURL: imageURL.toString());
      final docTest =
          FirebaseFirestore.instance.collection('Users').doc(userID);
      docTest.set(test.toJson());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
