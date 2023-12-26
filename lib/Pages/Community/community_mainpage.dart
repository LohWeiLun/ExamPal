import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Widgets/community_list.dart';
import 'add_community.dart';
import 'community_details.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late List<String> userCommunityNames = [];
  late List<String> otherCommunityNames = [];
  late List<Map<String, dynamic>> userCommunityDetails = [];
  late List<Map<String, dynamic>> otherCommunityDetails = [];

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    try {
      // Fetch user communities
      List<String> userCommunities = await _getUserCommunityNames();

      // Update the widget with the fetched data
      setState(() {
        userCommunityNames = userCommunities;
      });

      // Fetch other communities
      List<String> otherCommunities = await _getOtherCommunityNames();

      setState(() {
        otherCommunityNames = otherCommunities;
      });

      // Fetch details for user communities
      List<Map<String, dynamic>> userCommunitiesDetails =
          await _getCommunityDetails(userCommunityNames);
      setState(() {
        userCommunityDetails = userCommunitiesDetails;
      });

      // Fetch details for other communities
      List<Map<String, dynamic>> otherCommunitiesDetails =
          await _getCommunityDetails(otherCommunityNames);
      setState(() {
        otherCommunityDetails = otherCommunitiesDetails;
      });
    } catch (error) {
      // Handle errors
      print('Error fetching communities: $error');
      // Initialize community lists to empty lists in case of an error
      userCommunityNames = [];
      otherCommunityNames = [];
      userCommunityDetails = [];
      otherCommunityDetails = [];
    }
  }

  Future<List<String>> _getUserCommunityNames() async {
    try {
      // Fetch the user's community names from Firebase Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Get the community names array from the user document
      List<String> userCommunities =
          List<String>.from(userDoc.get('communityNames') ?? []);

      return userCommunities;
    } catch (error) {
      // Handle errors
      print('Error fetching user communities: $error');
      return [];
    }
  }

  Future<List<String>> _getOtherCommunityNames() async {
    try {
      // Fetch all community names from Firebase Firestore
      QuerySnapshot<Map<String, dynamic>> allCommunitiesSnapshot =
          await FirebaseFirestore.instance.collection('community').get();

      // Get all community names
      List<String> allCommunities = allCommunitiesSnapshot.docs
          .map((doc) => doc.get('communityName') as String)
          .toList();

      // Remove user's communities from all communities
      List<String> otherCommunities = allCommunities
          .where((community) => !userCommunityNames.contains(community))
          .toList();

      return otherCommunities;
    } catch (error) {
      // Handle errors
      print('Error fetching other communities: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getCommunityDetails(
      List<String> communityNames) async {
    try {
      List<Future<Map<String, dynamic>>> futures =
          communityNames.map((name) async {
        // Fetch community details from Firebase Firestore
        DocumentSnapshot<Map<String, dynamic>> communityDoc =
            await FirebaseFirestore.instance
                .collection('community')
                .doc(name)
                .get();

        // Get the community details
        Map<String, dynamic> communityDetails = communityDoc.data() ?? {};

        return communityDetails;
      }).toList();

      return await Future.wait(futures);
    } catch (error) {
      // Handle errors
      print('Error fetching community details: $error');
      return [];
    }
  }

  Future<void> _showPasswordDialog(String communityName) async {
    // Fetch user details from Firebase Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Get the user's community names array from the user document
    List<String> userCommunities =
        List<String>.from(userDoc.get('communityNames') ?? []);

    // Check if the user is the owner of the community
    bool isOwner = userCommunities.contains(communityName);

    if (isOwner) {
      // If the user is the owner, directly navigate to community detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityDetailPage(
            communityName: communityName,
            isPrivate: true,
          ),
        ),
      );
    } else {
      // If not the owner, show the password dialog
      String enteredPassword = '';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Key'),
            content: TextField(
              onChanged: (value) {
                enteredPassword = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Community Key',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Fetch community details from Firebase Firestore
                  DocumentSnapshot<Map<String, dynamic>> communityDoc =
                      await FirebaseFirestore.instance
                          .collection('community')
                          .doc(communityName)
                          .get();

                  // Validate the entered password
                  bool isPasswordValid =
                      validatePassword(enteredPassword, communityDoc);

                  if (isPasswordValid) {
                    // Close the dialog
                    Navigator.of(context).pop();

                    // Navigate to community detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityDetailPage(
                          communityName: communityName,
                          isPrivate: true,
                        ),
                      ),
                    );
                  } else {
                    // Show an error message or handle invalid password
                    print('Invalid Key');
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect key. Please try again.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    }
  }

  bool validatePassword(String enteredPassword,
      DocumentSnapshot<Map<String, dynamic>> communityDoc) {
    // Get the actual password for the community
    String actualPassword = communityDoc.get('password') ?? '';

    // Add your password validation logic here
    return enteredPassword == actualPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Stack(fit: StackFit.expand, children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/newBack.jpg',
            fit: BoxFit.cover,
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Your Community',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCommunityPage(),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Color(0xffc1e1e9),
                        child: Icon(
                          Icons.add,
                          size: 20.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // User Communities Section
                if (userCommunityNames.isEmpty)
                  const Center(
                      child: Text(
                    'No Communities Yet!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ))
                else
                  Column(
                    children: List.generate(userCommunityNames.length, (index) {
                      if (userCommunityDetails.length > index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                // Check if the community is private
                                if (userCommunityDetails[index]['isPrivate']) {
                                  // If private, show password dialog
                                  _showPasswordDialog(
                                      userCommunityNames[index]);
                                } else {
                                  // If not private, directly navigate to community detail page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommunityDetailPage(
                                        communityName:
                                            userCommunityNames[index],
                                        isPrivate: userCommunityDetails[index]
                                            ['isPrivate'],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: CommunityList(
                                title: userCommunityNames[index],
                                desc: 'You Are the Owner',
                                colorl: Colors.blue,
                                isPrivate: userCommunityDetails[index]
                                    ['isPrivate'],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      } else {
                        return Container(); // Return an empty container if details are not available yet
                      }
                    }),
                  ),
                const SizedBox(height: 10),
                // Other Communities Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Other Communities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (otherCommunityNames.isEmpty)
                  const Center(
                      child: Text(
                    'No Communities Yet!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ))
                else
                  Column(
                    children:
                        List.generate(otherCommunityNames.length, (index) {
                      if (otherCommunityDetails.length > index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                // Check if the community is private
                                if (otherCommunityDetails[index]['isPrivate']) {
                                  // If private, show password dialog
                                  _showPasswordDialog(
                                      otherCommunityNames[index]);
                                } else {
                                  // If not private, directly navigate to community detail page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommunityDetailPage(
                                        communityName:
                                            otherCommunityNames[index],
                                        isPrivate: otherCommunityDetails[index]
                                            ['isPrivate'],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: CommunityList(
                                title: otherCommunityNames[index],
                                desc: 'Other Community',
                                colorl: Colors.green,
                                isPrivate: otherCommunityDetails[index]
                                    ['isPrivate'],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      } else {
                        return Container(); // Return an empty container if details are not available yet
                      }
                    }),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
