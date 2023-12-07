import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'community_details.dart';
import 'community_mainpage.dart';

class AddCommunityPage extends StatefulWidget {
  @override
  _AddCommunityPageState createState() => _AddCommunityPageState();
}

class _AddCommunityPageState extends State<AddCommunityPage> {
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPrivate = false;
  final List<PlatformFile> _fileUploads = [];
  List<UploadTask> uploadTask = [];
  bool _obscurePassword = true;
  Map<int, double> uploadProgress = {};

  String? _validateCommunityName(String value) {
    if (value.isEmpty) {
      return 'Please enter a community name';
    }
    if (value.length > 20) {
      return 'Community name cannot exceed 20 characters';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (_isPrivate && value.isEmpty) {
      return 'Please enter a key for the private community';
    }
    return null;
  }

  String? _validateFileUploads(List<PlatformFile> files) {
    if (files.isEmpty) {
      return 'Please upload at least one file';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _communityNameController,
                decoration: const InputDecoration(labelText: 'Community Name'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Private Community'),
                  Switch(
                    value: _isPrivate,
                    onChanged: (value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (_isPrivate)
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_fileUploads.isEmpty)
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No files uploaded yet'),
                        ),
                      ),
                    for (int index = 0; index < _fileUploads.length; index++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('File: ${_fileUploads[index].name}'),
                              if (uploadProgress.containsKey(index))
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: uploadProgress[index] ?? 0.0,
                                  ),
                                ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  // Remove the file upload at the given index
                                  setState(() {
                                    _removeFile(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 16.0),
                    // Added space before the Upload File button
                    ElevatedButton(
                      onPressed: () {
                        _selectFile();
                      },
                      child: const Text('Upload File'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate inputs
                    String? communityNameError = _validateCommunityName(
                      _communityNameController.text,
                    );
                    String? passwordError = _validatePassword(
                      _passwordController.text,
                    );
                    String? fileUploadsError = _validateFileUploads(_fileUploads);

                    if(communityNameError != null){
                      _showErrorDialog(
                        'Validation Error',
                        communityNameError,
                      );
                      return;
                    }

                    if(passwordError != null){
                      _showErrorDialog(
                        'Validation Error',
                        passwordError,
                      );
                      return;
                    }

                    if (fileUploadsError != null) {
                      _showErrorDialog(
                        'Validation Error',
                        fileUploadsError,
                      );
                      return;
                    }
                    // If validation passes, proceed to store community information
                    _storeCommunityInfo();
                  },
                  child: const Text('Create Community'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future _selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    // Check if the selected file already exists in the list
    String selectedFilePath = result.files.first.path!;
    bool fileAlreadyExists = _fileUploads.any((file) => file.path == selectedFilePath);

    if (fileAlreadyExists) {
      _showErrorDialog(
        'Validation Error',
        'File with the same name already selected.',
      );
      return;
    }

    setState(() {
      _fileUploads.add(result.files.first);
    });
  }


  void _removeFile(int index) {
    setState(() {
      _fileUploads.removeAt(index);
    });
  }

  Future<void> _uploadFile() async {
    for (int i = 0; i < _fileUploads.length; i++) {
      final path =
          'community/${_communityNameController.text}/${_fileUploads[i].name}';
      final file = File(_fileUploads[i].path!);

      final ref = FirebaseStorage.instance.ref().child(path);

      // Use putFile directly to create UploadTask instances
      final uploadTask = ref.putFile(file);

      // Listen to the upload progress
      final streamSubscription = uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          uploadProgress[i] = progress;
        });
      });

      // Wait for the upload to complete
      await uploadTask.whenComplete(() {
        streamSubscription.cancel(); // Cancel the subscription after completion
      });
  }
    // Clear the lists after the upload is complete
    setState(() {
      _fileUploads.clear();
      uploadProgress.clear();
    });
  }

  Future<void> _storeCommunityInfo() async {
    try {
      String communityName = _communityNameController.text;
      bool isPrivate = _isPrivate;
      String password = _passwordController.text;

      // Check if the community name already exists
      bool communityExists = await _checkCommunityExistence(communityName);

      if (communityExists) {
        _showErrorDialog(
          'Validation Error',
          'Community with the same name already exists.',
        );
        return;
      }

      // Create a new document with the community name as the document ID
      await FirebaseFirestore.instance
          .collection('community')
          .doc(communityName)
          .set({
        'communityName': communityName,
        'isPrivate': isPrivate,
        'password': isPrivate ? password : null,
        'folderPath': 'community/$communityName',
      });

      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid).
      update({
        'communityNames': FieldValue.arrayUnion([communityName]),
      });

      await _uploadFile(); // Wait for files to be uploaded

      // You can add more fields as needed
      print('Community information stored successfully!');

      // Navigate to the community detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YourCommunityPage(),
        ),
      );
    } catch (error) {
      print('Error storing community information: $error');
      // Handle the error as needed
    }
  }

  Future<bool> _checkCommunityExistence(String communityName) async {
    // Check if a document with the provided community name exists
    DocumentSnapshot<Map<String, dynamic>> communityDoc = await FirebaseFirestore
        .instance
        .collection('community')
        .doc(communityName)
        .get();

    return communityDoc.exists;
  }

  _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

