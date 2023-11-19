import 'package:exampal/Models/course.dart';
import 'package:exampal/Pages/Figma/fastnotepage.dart';
import 'package:exampal/Pages/Timetable/schedule_page.dart';
import 'package:exampal/Pages/Timetable/timer_page.dart';
import 'package:exampal/Pages/community_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Widgets/custom_icon_button.dart';
import '../Login/updated_loginpage.dart';
import '../Notes/FileConversion_page.dart';
import '../Notes/recentnotes.dart';
import '../Voice-ToText/voicetotext.dart';

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
                            'Categories',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    fontSize: 22,
                                    // Adjust the font size as needed
                                    fontWeight: FontWeight.bold,
                                    // Make the text bold
                                    color: Colors.black),
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

  void navigateToCategoryPage(BuildContext context) {
    if (course.name == 'Schedule') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SchedulePage()),
      );
    } else if (course.name == 'Fast Note') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FastNoteFunctionPage()));
    } else if (course.name == 'Voice-To-Text') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VoiceToTextPage()));
    } else if (course.name == 'File Conversion') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => FileConversionPage()));
    } else if (course.name == 'Community') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CommunityPage()));
    } else if (course.name == 'Timer') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => TimerPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToCategoryPage(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
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
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 23,),
                  Text(course.name),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
