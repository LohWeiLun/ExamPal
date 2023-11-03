import 'package:flutter/material.dart';
import 'package:exampal/Pages/calendar_page.dart';
import 'package:exampal/Constants/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:exampal/Widgets/task_column.dart';
import 'package:exampal/Widgets/active_project_card.dart';
import 'package:exampal/Widgets/top_container.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();

  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }
}

class _SchedulePageState extends State<SchedulePage> {
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.menu,
                            color: LightColors.kDarkBlue, size: 30.0),
                        Icon(Icons.search,
                            color: LightColors.kDarkBlue, size: 25.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 90.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: 0.75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: LightColors.kRed,
                            backgroundColor: LightColors.kDarkYellow,
                            center: const CircleAvatar(
                              backgroundColor: LightColors.kBlue,
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                "assets/icons/profile.png",
                              ),
                            ),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Sourav Suman',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: LightColors.kDarkBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'App Developer',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendarPage()),
                            );
                          },
                          child: SchedulePage.calendarIcon(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    TaskColumn(
                      icon: Icons.alarm,
                      iconBackgroundColor: LightColors.kRed,
                      title: 'To Do',
                      subtitle: '5 tasks now. 1 started',
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TaskColumn(
                      icon: Icons.blur_circular,
                      iconBackgroundColor: LightColors.kDarkYellow,
                      title: 'In Progress',
                      subtitle: '1 tasks now. 1 started',
                    ),
                    const SizedBox(height: 15.0),
                    TaskColumn(
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
                    Row(
                      children: <Widget>[
                        ActiveProjectsCard(
                          cardColor: LightColors.kGreen,
                          loadingPercent: 0.25,
                          title: 'Medical App',
                          subtitle: '9 hours progress',
                        ),
                        const SizedBox(width: 20.0),
                        ActiveProjectsCard(
                          cardColor: LightColors.kRed,
                          loadingPercent: 0.6,
                          title: 'Making History Notes',
                          subtitle: '20 hours progress',
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        ActiveProjectsCard(
                          cardColor: LightColors.kDarkYellow,
                          loadingPercent: 0.45,
                          title: 'Sports App',
                          subtitle: '5 hours progress',
                        ),
                        const SizedBox(width: 20.0),
                        ActiveProjectsCard(
                          cardColor: LightColors.kBlue,
                          loadingPercent: 0.9,
                          title: 'Online Flutter Course',
                          subtitle: '23 hours progress',
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
