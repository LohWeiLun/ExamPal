import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:exampal/Constants/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:exampal/Widgets/task_column.dart';
import 'package:exampal/Widgets/active_project_card.dart';
import 'package:exampal/Widgets/top_container.dart';

import '../../Widgets/back_button.dart';
import 'add_schedule_ui.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  double completedPercentage = 0.75;
  String? title = 'Schedule Title';
  List<Map<String, dynamic>> generatedSchedule = [];

  Future _getDataFromDatabase(String docId) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("schedule");


    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("schedule")
        .doc(docId)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          title = snapshot.data()!["title"];
          generatedSchedule = snapshot.data()!["schedule"];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TopContainer(
                height: 230,
                width: width,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyBackButton(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: completedPercentage,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: LightColors.kRed,
                            backgroundColor: LightColors.kDarkYellow,
                            center: const CircleAvatar(
                              backgroundColor: LightColors.kBlue,
                              radius: 40.0,
                              backgroundImage: AssetImage(
                                "assets/icons/profile.png",
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                title!,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  color: LightColors.kDarkBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        subheading('My Tasks'),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    const TaskColumn(
                      icon: Icons.alarm,
                      iconBackgroundColor: LightColors.kRed,
                      title: 'To Do',
                      subtitle: '5 tasks now. 1 started',
                    ),
                    const SizedBox(height: 15.0),
                    const TaskColumn(
                      icon: Icons.check_circle_outline,
                      iconBackgroundColor: LightColors.kBlue,
                      title: 'Done',
                      subtitle: '18 tasks now. 13 started',
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    subheading('Active Projects'),
                    const SizedBox(height: 5.0),
                    const Row(
                      children: <Widget>[
                        ActiveProjectsCard(
                          loadingPercent: 0.25,
                          title: 'Medical App',
                          subtitle: '9 hours progress',
                          id: 'aaa',
                        ),
                        SizedBox(width: 20.0),
                        ActiveProjectsCard(
                          loadingPercent: 0.6,
                          title: 'Making History Notes',
                          subtitle: '20 hours progress',id: 'aaa',
                        ),
                      ],
                    ),
                    const Row(
                      children: <Widget>[
                        ActiveProjectsCard(
                          loadingPercent: 0.45,
                          title: 'Sports App',
                          subtitle: '5 hours progress',id: 'aaa',
                        ),
                        SizedBox(width: 20.0),
                        ActiveProjectsCard(
                          loadingPercent: 0.9,
                          title: 'Online Flutter Course',
                          subtitle: '23 hours progress',id: 'aaa',
                        ),
                      ],
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
