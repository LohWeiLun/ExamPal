import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exampal/Pages/Dictonary/dictonary.dart';
import 'package:exampal/Pages/Figma/testFastNote.dart';
import 'package:exampal/Pages/OCR/imageToText.dart';
import 'package:exampal/Pages/Timetable/schedule_mainpage.dart';
import 'package:exampal/Pages/UserProfile/settings.dart';
import 'package:exampal/Models/category.dart';
import 'package:exampal/Pages/Voice-ToText/voiceToTextFunction.dart';
import 'package:exampal/Widgets/circle_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:exampal/Widgets/search_textfield.dart';
import '../FileConversion/FileConversionPage.dart';
import 'fastnotepage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homepage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(
          children: [
            AppBar(),
            Expanded(
              child: Body(),
            ),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explore Categories",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 20,
          mainAxisSpacing: 24,
        ),
        itemBuilder: (context, index) {
          return CategoryCard(
            category: categoryList[index],
          );
        },
        itemCount: categoryList.length,
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  void navigateToCategoryPage(BuildContext context) {
    if (category.name == 'Schedule') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SchedulePage()));
    } else if (category.name == 'Fast Note') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FastNoteBackupFunctionPage()));
    } else if (category.name == 'Voice-To-Text') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const VoiceToTextFunctionPage()));
    } else if (category.name == 'File Conversion') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const FileConversionFunctionPage()));
    } else if (category.name == 'Image-To-Text') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ImageToTextPage()));
    } else if (category.name == 'Dictonary') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DictonaryPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToCategoryPage(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                category.thumbnail,
                height: 100, // Adjust the image size as needed
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(category.name),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "${category.noOfCourses.toString()} ",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    Key? key,
  }) : super(key: key);

  Future<String> getUsername() async {
    // Get current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Retrieve user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      String username = userDoc['name'];

      return username;
    }

    return 'User'; // Default if username is not found
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            Color(0x66886ff2),
            Color(0x666849ef),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            left: -10,
            child: Image.asset(
              'assets/logo/wordLogo.png', // Logo Image
              height: 100, // Adjust size as needed
              width: 170,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loader while fetching data
                    } else if (snapshot.hasError) {
                      return Text('Error fetching data'); // Show error if any
                    } else {
                      String username = snapshot.data ?? 'User';
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\n\n Hello, $username",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          const SearchTextField(),
                        ],
                      );
                    }
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CircleButton(
                    icon: Icons.settings,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
