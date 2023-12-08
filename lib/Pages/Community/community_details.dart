import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'community_mainpage.dart';

class CommunityDetailPage extends StatefulWidget {
  final String communityName;

  final bool isPrivate;

  const CommunityDetailPage({
    Key? key,
    required this.communityName,
    required this.isPrivate,
  }) : super(key: key);

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  late Future<List<String>> futureFiles;
  List<PlatformFile> _fileUploads = [];
  String communityPassword = '';
  String newKey ='';
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    futureFiles = displayFiles('community/${widget.communityName}');
    if (widget.isPrivate) {
      // Fetch the community password for private communities
      fetchCommunityPassword();
    }
    checkOwner(widget.communityName);
  }

  Future<void> fetchCommunityPassword() async {
    try {
      // Fetch the community password from Firestore
      DocumentSnapshot communityDoc = await FirebaseFirestore.instance
          .collection('community')
          .doc(widget.communityName)
          .get();

      setState(() {
        communityPassword = communityDoc.get('password') ?? '';
      });
    } catch (error) {
      print('Error fetching community password: $error');
      // Handle the error as needed
    }
  }

  Future<void> changeCommunityPassword(String newPassword) async {
    try {
      // Validate the new password
      if (newPassword.isEmpty) {
        // Display a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a non-empty password.'),
          ),
        );
        return;
      }

      if (newPassword.length > 20) {
        // Display a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password cannot be longer than 20 characters.'),
          ),
        );
        return;
      }

      // Update the community password in Firestore
      await FirebaseFirestore.instance
          .collection('community')
          .doc(widget.communityName)
          .update({
        'password': newPassword,
      });

      // Display a SnackBar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Community key changed successfully.'),
        ),
      );

      // Replace the current page with a new instance of CommunityDetailPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CommunityDetailPage(
            communityName: widget.communityName,
            isPrivate: widget.isPrivate,
          ),
        ),
      );
    } catch (error) {
      print('Error changing community key: $error');
      // Handle the error as needed
    }
  }


  Future<void> deleteCommunity() async {
    try {
      // 1. Delete files in Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('community/${widget.communityName}');
      await ref.listAll().then((result) async {
        for (var item in result.items) {
          await item.delete();
        }
      });

      // 2. Delete the community document in Firestore
      await FirebaseFirestore.instance
          .collection('community')
          .doc(widget.communityName)
          .delete();

      // 3. Update user document in Firestore (if the user is the owner)
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final userCommunities =
          List<String>.from(userDoc.get('communityNames') ?? []);
      if (userCommunities.contains(widget.communityName)) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'communityNames': FieldValue.arrayRemove([widget.communityName]),
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityPage(),
        ),
      );
    } catch (error) {
      print('Error deleting community: $error');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.communityName}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'delete') {
                // Show delete confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                        'Are you sure you want to delete this community?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Delete the whole community
                            deleteCommunity();
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              } else if (value == 'add') {
                // Upload files to the community
                _selectAndUploadFiles();
              } else if (value == 'changePassword' && widget.isPrivate) {
                // Show change password dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Change Community Key'),
                      content: Container(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current Key: ${communityPassword}'),
                            SizedBox(height: 10), // Add space between current password and input field
                            TextField(
                              decoration: InputDecoration(labelText: 'New Key'),
                              onChanged: (value) {
                                setState(() {
                                  newKey = value.trim();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Change the community password
                            changeCommunityPassword(newKey); // Pass the new password
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (isOwner)
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              ),
              if (isOwner)
              const PopupMenuItem<String>(
                value: 'add',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add File'),
                ),
              ),
              if (widget.isPrivate && isOwner) // Only show if the community is private
                const PopupMenuItem<String>(
                  value: 'changePassword',
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No files available.'));
          } else {
            List<String> files = snapshot.data!;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                String fileName = files[index];
                return ListTile(
                  title: Text(fileName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () async {
                          // Implement the download functionality here
                          try {
                            // Get the reference to the file in Firebase Storage
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child('community/${widget.communityName}/$fileName');

                            // Get the download URL for the file
                            final String downloadURL = await ref.getDownloadURL();

                            // Use Dio package to download the file
                            Dio dio = Dio();
                            final savePath = '/storage/emulated/0/Download/$fileName'; // Set your desired download path
                            await dio.download(downloadURL, savePath);

                            // Show a message or perform actions upon successful download
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('File downloaded successfully'),
                              ),
                            );
                          } catch (error) {
                            print('Error downloading file: $error');
                            // Handle download errors here
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error downloading file'),
                              ),
                            );
                          }
                        },
                      ),
                      if(isOwner)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Show delete confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                  'Are you sure you want to delete this file?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Delete the file
                                      await deleteFile(
                                          'community/${widget.communityName}/$fileName');
                                      // Refresh the page to get the updated list of files
                                      setState(() {
                                        futureFiles = displayFiles(
                                            'community/${widget.communityName}');
                                      });
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> checkOwner(String communityName) async {
    // Fetch user details from Firebase Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc =
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Get the user's community names array from the user document
    List<String> userCommunities =
    List<String>.from(userDoc.get('communityNames') ?? []);

    // Check if the user is the owner of the community
    isOwner = userCommunities.contains(communityName);

  }

  Future<void> deleteFile(String filePath) async {
    try {
      // Delete the file from Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(filePath);
      await ref.delete();
    } catch (error) {
      print('Error deleting file: $error');
      // Handle the error as needed
    }
  }

  Future<void> _selectAndUploadFiles() async {
    // Use FilePicker to allow users to select files
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;

    // Check if the selected files already exist in the community
    List<String> existingFiles =
        await displayFiles('community/${widget.communityName}');
    List<String> selectedFileNames =
        result.files!.map((file) => file.name).toList();
    bool filesAlreadyExist =
        existingFiles.any((file) => selectedFileNames.contains(file));

    if (filesAlreadyExist) {
      // Display a SnackBar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected files already exist in the community.'),
        ),
      );
      return;
    }

    // Check if the same files are selected
    bool sameFilesSelected =
        Set.from(existingFiles).containsAll(selectedFileNames);

    if (sameFilesSelected) {
      // Display a SnackBar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The same files are already selected.'),
        ),
      );
      return;
    }

    // Set the selected files for upload
    setState(() {
      _fileUploads = result.files;
    });

    // Show file upload confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm File Upload'),
          content: const Text(
              'Are you sure you want to upload files to this community?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Validate if files are selected for upload
                if (_fileUploads.isEmpty) {
                  // Display a SnackBar to inform the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please upload at least one file.'),
                    ),
                  );
                  // Close the dialog
                  Navigator.of(context).pop();
                  return;
                }
                // Upload files
                Navigator.of(context).pop();
                await _uploadFilesToStorage();
                // Refresh the page to get the updated list of files
                setState(() {
                  futureFiles =
                      displayFiles('community/${widget.communityName}');
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> displayFiles(String communityPath) async {
    Reference ref = FirebaseStorage.instance.ref().child(communityPath);

    try {
      ListResult result = await ref.listAll();
      // Get filenames for each item and add them to the userFiles list
      List<String> fileNames =
          result.items.map((reference) => reference.name).toList();

      return fileNames;
    } catch (e) {
      print('Error fetching user files: $e');
      // Handle errors here
      return [];
    }
  }


  Future<void> _uploadFilesToStorage() async {
    for (int i = 0; i < _fileUploads.length; i++) {
      final path = 'community/${widget.communityName}/${_fileUploads[i].name}';
      final file = File(_fileUploads[i].path!);

      final ref = FirebaseStorage.instance.ref().child(path);

      // Use putFile directly to create UploadTask instances
      final uploadTask = ref.putFile(file);

      // Listen to the upload progress
      final streamSubscription =
          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          // Upload progress can be displayed if needed
          // uploadProgress[i] = progress;
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
      // uploadProgress.clear(); // Uncomment if you want to clear upload progress
    });
  }
}
