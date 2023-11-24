import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exampal/Pages/Timetable/schedule_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class StudyScheduleForm extends StatefulWidget {
  @override
  _StudyScheduleFormState createState() => _StudyScheduleFormState();
}

class _StudyScheduleFormState extends State<StudyScheduleForm> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final TextEditingController examTitleController = TextEditingController();
  DateTime? examDate;
  DateTime? startDate;
  String? studyMode = 'focus';
  List<Map<String, dynamic>> topics = [];
  List<Map<String, dynamic>> generatedSchedule = [];

  bool _titleValid = true;

  addScheduleData() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("schedule");

    String docId = ref.doc().id;

    setState(() {
      examTitleController.text.trim().isEmpty
          ? _titleValid = false
          : _titleValid = true;
    });

    if (_titleValid) {
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("schedule")
          .doc(docId)
          .set({
        "title": examTitleController.text,
        "id": docId,
        "startDate": startDate,
        "examDate": examDate,
        "studyMode": studyMode,
        "topics": topics,
        "schedule": generatedSchedule,
      });

      SnackBar snackbar = const SnackBar(content: Text("Schedule Added!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the function when the app starts
    updateFunctionIfNeeded();
    initializeNotifications();
  }

  Future<void> updateFunctionIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the last execution date
    String? lastExecutionDate = prefs.getString('lastExecutionDate');

    // Get the current date
    DateTime now = DateTime.now();
    String currentDate = "${now.year}-${now.month}-${now.day}";

    // Check if the dates are different
    if (lastExecutionDate != currentDate) {
      // Call the update function
      await ScheduleGenerator.updateScheduleDates();

      // Update the stored date
      prefs.setString('lastExecutionDate', currentDate);
    }
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('exampal_logo');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Schedule a daily notification at midnight
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Update',
      'Check your schedule for today!',
      _nextInstanceOfMidnight(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel',
          'Daily Notification',
          importance: Importance.max,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfMidnight() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + 1,
      0,
      0,
    );
    return scheduledDate;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Study Schedule'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: examTitleController,
                decoration: const InputDecoration(labelText: 'Exam Title'),
              ),
              const SizedBox(height: 10),
              buildDateField('Exam Date', examDate, (date) {
                setState(() {
                  examDate = date;
                });
              }),
              const SizedBox(height: 10),
              buildDateField('Start Date', startDate, (date) {
                setState(() {
                  startDate = date;
                });
              }),
              const SizedBox(height: 10),
              buildStudyModeDropdown(),
              const SizedBox(height: 10),
              buildTopicsInput(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate input before generating the study schedule
                  if (validateInput()) {
                    // Call the function to generate the study schedule
                    generatedSchedule = ScheduleGenerator.generateSchedule(
                      examTitle: examTitleController.text,
                      examDate: examDate!,
                      startDate: startDate!,
                      studyMode: studyMode!,
                      topics: topics,
                    );

                    // Display or use the generated study schedule as needed
                    print(generatedSchedule);
                    addScheduleData();
                  }
                },
                child: const Text('Generate Study Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateField(String label, DateTime? selectedDate,
      Function(DateTime?) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
              text: selectedDate != null ? formatDate(selectedDate) : ''),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  Widget buildStudyModeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Focus'),
      value: studyMode,
      onChanged: (String? value) {
        setState(() {
          studyMode = value;
        });
      },
      items: const [
        DropdownMenuItem<String>(
          value: 'focus',
          child: Text('Focus'),
        ),
        DropdownMenuItem<String>(
          value: 'flexible',
          child: Text('Flexible'),
        ),
      ],
    );
  }

  Widget buildTopicsInput() {
    return Column(
      children: [
        for (int i = 0; i < topics.length; i++)
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Topic ${i + 1}'),
                  initialValue: topics[i]['topic'] ?? 'Topic ${i + 1}',
                  onChanged: (value) {
                    setState(() {
                      if (value.trim().isNotEmpty) {
                        topics[i]['topic'] = value;
                      } else {
                        topics[i]['topic'] = 'Topic ${i + 1}';
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: buildDifficultyDropdown(i),
              ),
              if (i > 0)
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      topics.removeAt(i);
                    });
                  },
                ),
            ],
          ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              int newIndex = topics.length + 1;
              topics.add({'topic': 'Topic $newIndex', 'difficulty': 3});
            });
          },
          child: const Text('Add Topic'),
        ),
      ],
    );
  }

  Widget buildDifficultyDropdown(int index) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: 'Difficulty'),
      value: topics[index]['difficulty'],
      onChanged: (int? value) {
        setState(() {
          topics[index]['difficulty'] = value;
        });
      },
      items: [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  bool validateInput() {
    if (examTitleController.text.trim().isEmpty) {
      _showErrorDialog(
          'Empty Exam Title', 'Please enter a non-empty exam title.');
      return false;
    }

    if (startDate == null || examDate == null) {
      _showErrorDialog(
          'Invalid Dates', 'Please select valid start and exam dates.');
      return false;
    }

    if (startDate!.isAfter(examDate!)) {
      _showErrorDialog(
          'Invalid Dates', 'Start date must be before the exam date.');
      return false;
    }

    if (topics.isEmpty) {
      _showErrorDialog('No Topics', 'Please add at least one topic.');
      return false;
    }

    int daysBetween = examDate!.difference(startDate!).inDays;
    if (daysBetween < topics.length) {
      _showErrorDialog('Insufficient Study Days',
          'There must be enough study days between start date and exam date for each topic.');
      return false;
    }

    return true;
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
