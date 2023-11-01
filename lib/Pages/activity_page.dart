import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Activity> activities = [
    Activity(
      friendName: 'Alice',
      activityType: ActivityType.post,
      activityText: 'Posted a new photo',
    ),
    Activity(
      friendName: 'Bob',
      activityType: ActivityType.like,
      activityText: 'Liked your post',
    ),
    Activity(
      friendName: 'Carol',
      activityType: ActivityType.comment,
      activityText: 'Commented on your photo',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Page'),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return ActivityCard(activity: activities[index]);
        },
      ),
    );
  }
}

class Activity {
  final String friendName;
  final ActivityType activityType;
  final String activityText;

  Activity({required this.friendName, required this.activityType, required this.activityText});
}

enum ActivityType { post, like, comment }

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    String activityTypeText = '';

    switch (activity.activityType) {
      case ActivityType.post:
        activityTypeText = 'posted a';
        break;
      case ActivityType.like:
        activityTypeText = 'liked your';
        break;
      case ActivityType.comment:
        activityTypeText = 'commented on your';
        break;
    }

    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text('${activity.friendName} $activityTypeText activity'),
        subtitle: Text(activity.activityText),
      ),
    );
  }
}