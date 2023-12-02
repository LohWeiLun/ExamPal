import 'package:exampal/Models/course.dart';
import 'package:exampal/Pages/Figma/testFastNote.dart';
import 'package:exampal/Pages/FileConversion/FileConversionPage.dart';
import 'package:exampal/Pages/OCR/imageToText.dart';
import 'package:exampal/Pages/UserProfile/profile_page.dart';
import 'package:exampal/Pages/Voice-ToText/voiceToTextFunction.dart';
import 'package:exampal/Pages/community_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Widgets/custom_icon_button.dart';
import '../Community/community_mainpage.dart';
import '../Login/updated_loginpage.dart';
import '../Timetable/schedule_mainpage.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          child: Text(
                            'Services',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 22, // Adjust the font size as needed
                              fontWeight: FontWeight.bold, // Make the text bold
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: CustomIconButton(
                          height: 35,
                          width: 35,
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    shrinkWrap: true,
                    itemBuilder: (_, int index) {
                      return CourseContainer(
                        course: courses[index],
                      );
                    },
                    itemCount: courses.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseContainer extends StatelessWidget {
  final Course course;
  const CourseContainer({
    Key? key,
    required this.course,
  }) : super(key: key);

  void navigateToPage(BuildContext context) {
    switch (course.name) {
      case "Schedule":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchedulePage(), // Navigate to SchedulePage
          ),
        );
        break;
      case "Notes Summarization":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FastNoteBackupFunctionPage(), // Navigate to FastNotePage
          ),
        );
        break;
      case "Voice To Text":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceToTextFunctionPage(), // Navigate to VoiceToTextPage
          ),
        );
        break;
      case "File Conversion":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FileConversionFunctionPage(), // Navigate to VoiceToTextPage
          ),
        );
        break;
      case "Image To Text Recognition":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageToTextPage(), // Navigate to VoiceToTextPage
          ),
        );
        break;
      case "Community":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YourCommunityPage(), // Navigate to VoiceToTextPage
          ),
        );
        break;
      case "Profile":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(), // Navigate to VoiceToTextPage
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToPage(context), // Navigate based on the course selected
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  course.thumbnail,
                  height: 60,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        course.name,
                        style: TextStyle(
                          // You can customize the text style here if needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}