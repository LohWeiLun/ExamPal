import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleGenerator {
  static List<Map<String, dynamic>> generateSchedule({
    required String examTitle,
    required DateTime examDate,
    required DateTime startDate,
    required String studyMode,
    required List<Map<String, dynamic>> topics,
  }) {
    List<Map<String, dynamic>> schedule = [];

    int totalDays = examDate.difference(startDate).inDays;
    int maxStudyHoursPerDay = 4;
    int totalStudyTime = totalDays * maxStudyHoursPerDay;

    // Remove importance factor
    List<Map<String, dynamic>> weightedTopics = topics;

    // Calculate study time based on difficulty
    List<Map<String, dynamic>> studyTimePerTopic =
    calculateStudyTimePerTopic(weightedTopics, totalStudyTime);

    // Apply study mode preference
    List<Map<String, dynamic>> distributedTopics =
    applyStudyModePreference(studyMode, studyTimePerTopic);

    DateTime currentDate = startDate;
    bool taskCompletion = false;

    for (int i = 0; i < totalDays; i++) {
      if (currentDate.isBefore(examDate)) {
        Map<String, dynamic> sessionTopic =
        distributedTopics[i % distributedTopics.length];

        // Calculate session duration based on difficulty
        double sessionDuration =
        calculateSessionDuration(sessionTopic['difficulty']);

        // Check if the session duration exceeds the maximum limit
        if (sessionDuration > maxStudyHoursPerDay) {
          sessionDuration = maxStudyHoursPerDay.toDouble();
        }

        schedule.add({
          'date': currentDate,
          'topic': sessionTopic['topic'],
          'duration': sessionDuration,
          'complete': taskCompletion,
        });

        currentDate = currentDate.add(Duration(days: 1));
      }
    }

    return schedule;
  }

  static int calculateDailyStudyTime(String studyMode) {
    // Adjust the daily study time based on study mode
    return studyMode == 'focus' ? 3 : 2;
  }

  static List<Map<String, dynamic>> calculateWeightedTopics(
      List<Map<String, dynamic>> topics) {
    // Add an importance factor to each topic
    return topics.map((topic) {
      return {
        'topic': topic['topic'],
        'difficulty': topic['difficulty'],
        'importance': topic['importance'] ?? 1, // Default importance is 1
      };
    }).toList();
  }

  static List<Map<String, dynamic>> calculateStudyTimePerTopic(
      List<Map<String, dynamic>> topics, int totalStudyTime) {
    double totalDifficulty =
        topics.fold(0, (sum, topic) => sum + topic['difficulty']);

    return topics.map((topic) {
      double studyTime =
          (topic['difficulty'] / totalDifficulty) * totalStudyTime;

      return {
        'topic': topic['topic'],
        'studyTime': studyTime,
        'difficulty': topic['difficulty'],
        'importance': topic['importance'],
      };
    }).toList();
  }

  static List<Map<String, dynamic>> applyStudyModePreference(
      String studyMode, List<Map<String, dynamic>> studyTimePerTopic) {
    if (studyMode == 'focus') {
      // Sort topics based on difficulty for focus mode
      studyTimePerTopic
          .sort((a, b) => b['difficulty'].compareTo(a['difficulty']));
    } else {
      // Shuffle topics for flexible mode
      studyTimePerTopic.shuffle();
    }

    return studyTimePerTopic;
  }

  static double calculateSessionDuration(int difficulty) {
    // Map difficulty levels to study hours
    Map<int, double> difficultyToHours = {
      1: 1.0,
      2: 1.5,
      3: 2.0,
      4: 2.5,
      5: 3.0,
    };

    // Retrieve the study hours based on the difficulty level
    double baseDuration = difficultyToHours[difficulty] ?? 2.0;

    return baseDuration;
  }

  static Future<void> updateScheduleDates() async {
    DateTime currentDate = DateTime.now();

    try {
      // Fetch data from Firebase
      List<Map<String, dynamic>> schedule = await fetchScheduleFromFirebase();

      for (int i = 0; i < schedule.length; i++) {
        DateTime sessionDate = schedule[i]['date'].toDate();
        bool taskCompletion = schedule[i]['complete'];

        // Check if the session date has passed and the task is not complete
        if (currentDate.isAfter(sessionDate) && !taskCompletion) {
          // Increment session date to the next day
          schedule[i]['date'] =
              Timestamp.fromDate(sessionDate.add(Duration(days: 1)));
        }
      }

      // Update the changes back to Firebase
      await updateScheduleInFirebase(schedule);
    } catch (error) {
      print("Error updating schedule: $error");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchScheduleFromFirebase() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection("user")
            .doc(user.uid)
            .collection("schedule")
            .get();

        return snapshot.docs.map((doc) => doc.data()).toList();
      }
    } catch (error) {
      print("Error fetching schedule from Firebase: $error");
    }

    return [];
  }

  static Future<void> updateScheduleInFirebase(
      List<Map<String, dynamic>> schedule) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("user")
            .doc(user.uid)
            .collection("schedule")
            .doc()
            .update({'schedule': schedule});
      }
    } catch (error) {
      print("Error updating schedule in Firebase: $error");
    }
  }

  void deleteTask(String docId) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("schedule")
        .doc(docId)
        .delete();
  }

  static void updateTaskStatus(String id, int index, bool isDone) async {
    try {
      // Fetch the document
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection("user")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("schedule")
              .doc(id)
              .get();

      // Get the current schedule array
      List<dynamic> schedule = documentSnapshot.data()?['schedule'] ?? [];

      // Update the 'complete' field for the specified index
      if (index >= 0 && index < schedule.length) {
        schedule[index]['complete'] = isDone;
      }

      // Update the document with the modified schedule array
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("schedule")
          .doc(id)
          .update({
        'schedule': schedule,
      });

      print('Task status updated successfully');
    } catch (error) {
      print('Error updating task status: $error');
    }
  }

  static Future<void> updatePastSchedules() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the user's schedules
      QuerySnapshot<Map<String, dynamic>> schedulesSnapshot =
          await FirebaseFirestore.instance
              .collection("user")
              .doc(userId)
              .collection("schedule")
              .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      DateTime now = DateTime.now();
      DateTime currentDate = DateTime(now.year, now.month, now.day);

      // Loop through each schedule
      for (QueryDocumentSnapshot<Map<String, dynamic>> scheduleDoc
          in schedulesSnapshot.docs) {
        List<dynamic> schedule = scheduleDoc['schedule'] ?? [];

        // Check each session's date
        for (int i = 0; i < schedule.length; i++) {
          Map<String, dynamic> session = schedule[i];
          DateTime sessionDate = (session['date'] as Timestamp).toDate();
          bool isCompleted = session['complete'] ?? false;

          // Check if the session date is in the past and the task is not completed
          if (!isCompleted && sessionDate.isBefore(currentDate)) {
            // Update the session's date to the current date
            schedule[i]['date'] = Timestamp.fromDate(currentDate);
          }
        }

        // Update the schedule in the batch
        batch.update(
          FirebaseFirestore.instance
              .collection("user")
              .doc(userId)
              .collection("schedule")
              .doc(scheduleDoc.id),
          {'schedule': schedule},
        );
      }

      // Commit the batch update
      await batch.commit();
      print('Past schedules (not completed) updated successfully!');
    } catch (error) {
      print('Error updating past schedules: $error');
    }
  }
}
