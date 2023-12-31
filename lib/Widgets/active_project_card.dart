import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../Pages/Timetable/schedule_details.dart';

class ActiveProjectsCard extends StatelessWidget {
  final double loadingPercent;
  final String title;
  final String subtitle;
  final String id;

  const ActiveProjectsCard({
    Key? key,
    required this.loadingPercent,
    required this.title,
    required this.subtitle,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to schedule details page with the corresponding ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleDetailsPage(scheduleId: id),
          ),
        );
      },
      child: Flexible(
        flex: 1,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: CircularPercentIndicator(
                    animation: true,
                    radius: 35.0,
                    percent: loadingPercent,
                    lineWidth: 5.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.white10,
                    progressColor: Colors.white,
                    center: Text(
                      '${(loadingPercent * 100).round()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}
