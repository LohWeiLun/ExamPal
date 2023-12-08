import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:exampal/Pages/UserProfile/settings.dart';
import 'package:flutter/material.dart';
import 'package:exampal/Constants/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../Constants/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? name = '';
  String? email = '';
  String? avatar = '';

  bool _nameValid = true;
  bool _emailValid = true;
  String? photoUrl;

  Uint8List? _image;

  TextEditingController editNameController = TextEditingController();
  TextEditingController editEmailController = TextEditingController();

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!["name"];
          email = snapshot.data()!["email"];
          photoUrl = snapshot.data()!["photoUrl"];
        });
      }
    });
  }

  int maxName = 40;

  updateProfileData() {
    setState(() {
      editNameController.text.trim().length > maxName ||
          editNameController.text.trim().isEmpty
          ? _nameValid = false
          : _nameValid = true;
      editEmailController.text.trim().isNotEmpty ||
          EmailValidator.validate(editEmailController.text.trim())
          ? _emailValid = true
          : _emailValid = false;
    });

    if (_nameValid && _emailValid) {
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "name": editNameController.text,
        "email": editEmailController.text,
      });

      SnackBar snackbar = const SnackBar(content: Text("Profile Updated!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);

      if (_image != null) {
        // If an image is selected, update the image
        uploadImageAndUpdateFirebase();
      }
    }
  }



  void uploadImageAndUpdateFirebase() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = imageBytes;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_profile_images')
              .child('${currentUser.uid}.jpg');

          final metadata = SettableMetadata(contentType: 'image/jpeg');
          final uploadTask = storageRef.putData(_image!, metadata);

          final TaskSnapshot downloadUrl = await uploadTask;

          if (downloadUrl.state == TaskState.success) {
            final imageUrl = await downloadUrl.ref.getDownloadURL();
            setState(() {
              photoUrl = imageUrl;
            });

            await FirebaseFirestore.instance
                .collection("user")
                .doc(currentUser.uid)
                .update({"photoUrl": imageUrl});

            final snackbar =
            const SnackBar(content: Text("Image Updated!"));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          } else {
            final snackbar =
            const SnackBar(content: Text("Image upload failed"));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        }
      } catch (e) {
        final snackbar = const SnackBar(content: Text("Error uploading image"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: lightBlue2,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 10),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: photoUrl != null && photoUrl!.isNotEmpty
                              ? NetworkImage(photoUrl!) as ImageProvider<Object>
                              : AssetImage("assets/icons/profile.png"),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          uploadImageAndUpdateFirebase();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor,
                            ),
                            color: Colors.grey,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: editNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: "Full Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: _nameValid
                        ? null
                        : "Name exceeded max limit ($maxName characters)",
                    hintText: name!,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: editEmailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: "Email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText:
                    _emailValid ? null : "Email is invalid",
                    hintText: email!,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      updateProfileData();
                    },
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}