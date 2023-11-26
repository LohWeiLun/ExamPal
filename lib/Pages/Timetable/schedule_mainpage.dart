// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:exampal/Pages/Timetable/schedule_generator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:exampal/Constants/colors.dart';
// import 'package:exampal/Widgets/active_project_card.dart';
// import '../../Widgets/todo_list_item.dart';
// import 'add_schedule_ui.dart';
//
// class SchedulePage extends StatefulWidget {
//   const SchedulePage({Key? key}) : super(key: key);
//
//   @override
//   State<SchedulePage> createState() => _SchedulePageState();
// }
//
// class _SchedulePageState extends State<SchedulePage> {
//   double completedPercentage = 0.75;
//
//   late List<Map<String, dynamic>> todaysTasks = [];
//   late List<Map<String, dynamic>> scheduleList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     ScheduleGenerator.updatePastSchedules();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     try {
//       // Fetch schedule list
//       scheduleList = await getScheduleList();
//
//       // Fetch today's tasks
//       todaysTasks = await getTodaysTasks();
//
//       // Trigger a rebuild of the widget
//       setState(() {});
//     } catch (error) {
//       // Handle errors
//       print('Error fetching data: $error');
//       // Initialize scheduleList to an empty list in case of an error
//       scheduleList = [];
//       todaysTasks = [];
//     }
//   }
//
//   Text subheading(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         color: LightColors.kDarkBlue,
//         fontSize: 20.0,
//         fontWeight: FontWeight.w700,
//         letterSpacing: 1.2,
//       ),
//     );
//   }
//
//   static CircleAvatar circleAddSchedule() {
//     return const CircleAvatar(
//       radius: 25.0,
//       backgroundColor: Color(0xffc1e1e9),
//       child: Icon(
//         Icons.add,
//         size: 20.0,
//         color: Colors.black87,
//       ),
//     );
//   }
//
//   List<ActiveProjectsCard> buildActiveProjectCards(
//       List<Map<String, dynamic>> scheduleList) {
//     return scheduleList.map((schedule) {
//       String title = schedule['title'];
//       int totalSessions = schedule['totalSessions'];
//       int completedSessions = schedule['completedSessions'];
//       double completionPercentage = schedule['completionPercentage'];
//       String id = schedule['scheduleId'];
//
//       return ActiveProjectsCard(
//         loadingPercent: completionPercentage,
//         title: title,
//         subtitle: '$completedSessions of $totalSessions sessions completed',
//         id: id,
//       );
//     }).toList();
//   }
//
//   List<Widget> buildTodoListItems(List<Map<String, dynamic>> todaysTasks) {
//     return todaysTasks.map((task) {
//       String text = '${task['topic']} - ${task['duration']} hours';
//       bool isChecked = task['complete'];
//       int sIndex = task['sessionIndex'];
//       String sId = task['scheduleId'];
//
//       return TodoListItem(
//         text: text,
//         isChecked: isChecked,
//         id: sId,
//         index: sIndex,
//         onPress: () async {
//           isChecked = !isChecked;
//           ScheduleGenerator.updateTaskStatus(
//             sId,
//             sIndex,
//             isChecked,
//           );
//           await fetchData();
//         },
//       );
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<ActiveProjectsCard> activeProjectCards =
//         buildActiveProjectCards(scheduleList);
//
//     List<Widget> rows = [];
//     if (scheduleList.isEmpty) {
//       // Show a message when there are no schedules
//       rows.add(
//         const Padding(
//           padding: EdgeInsets.symmetric(vertical: 20.0),
//           child: Text(
//             "No Schedule Yet!",
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 18.0,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       );
//     } else {
//       for (int i = 0; i < activeProjectCards.length; i++) {
//         rows.add(
//           Padding(
//             padding: const EdgeInsets.only(bottom: 5.0),
//             child: activeProjectCards[i],
//           ),
//         );
//       }
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(' Schedules'),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 color: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                   vertical: 15.0,
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     subheading("Today's To Do"),
//                     const SizedBox(height: 5.0),
//                   ],
//                 ),
//               ),
//               Container(
//                 color: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                   vertical: 10.0,
//                 ),
//                 child: todaysTasks.isEmpty
//                     ? const Center(
//                         child: Text(
//                           "There are no tasks today!",
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       )
//                     : Column(
//                         children: buildTodoListItems(todaysTasks),
//                       ),
//               ),
//               const SizedBox(height: 15.0),
//               Container(
//                 color: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                   vertical: 15.0,
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         subheading('Your Schedules'),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => StudyScheduleForm()),
//                             );
//                           },
//                           child: circleAddSchedule(),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 color: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                   vertical: 10.0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: rows,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// Future<List<Map<String, dynamic>>> getTodaysTasks() async {
//   try {
//     // Fetch schedules for the user from Firebase Firestore
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
//         .instance
//         .collection("user")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection("schedule")
//         .get();
//
//     List<Map<String, dynamic>> todaysTasks = [];
//
//     DateTime now = DateTime.now();
//     DateTime today = DateTime(now.year, now.month, now.day);
//     DateTime tomorrow = today.add(const Duration(days: 1));
//
//     for (QueryDocumentSnapshot<Map<String, dynamic>> doc
//     in querySnapshot.docs) {
//       List<dynamic> schedule = doc['schedule'] ?? [];
//
//       for (Map<String, dynamic> session in schedule) {
//         DateTime sessionDate = (session['date'] as Timestamp).toDate();
//
//         // Check if the session is for today
//         if (sessionDate.isAtSameMomentAs(today) || sessionDate.isAfter(today) && sessionDate.isBefore(tomorrow)) {
//           // Add the session data to todaysTasks
//           Map<String, dynamic> taskData = {
//             'scheduleId': doc.id,
//             'sessionIndex': schedule.indexOf(session),
//             ...session,
//           };
//           todaysTasks.add(taskData);
//         }
//       }
//     }
//     print(todaysTasks);
//     return todaysTasks;
//   } catch (error) {
//     print('Error fetching todaysTasks: $error');
//     return [];
//   }
// }
//
//   Future<List<Map<String, dynamic>>> getScheduleList() async {
//   try {
//     // Fetch schedules for the user from Firebase Firestore
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
//         .instance
//         .collection("user")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection("schedule")
//         .get();
//
//     List<Map<String, dynamic>> scheduleList = [];
//
//     for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
//       List<dynamic> schedule = doc['schedule'] ?? [];
//
//       int totalSessions = schedule.length;
//       int completedSessions =
//           schedule.where((session) => session['complete'] == true).length;
//
//       // Calculate the percentage of completion
//       double completionPercentage =
//       totalSessions > 0 ? (completedSessions / totalSessions) : 0.0;
//
//       // Add schedule information to scheduleList
//       Map<String, dynamic> scheduleData = {
//         'scheduleId': doc.id,
//         'title': doc['title'],
//         'totalSessions': totalSessions,
//         'completedSessions': completedSessions,
//         'completionPercentage': completionPercentage,
//       };
//       scheduleList.add(scheduleData);
//     }
//     print(scheduleList);
//     return scheduleList;
//   } catch (error) {
//     print('Error fetching scheduleList: $error');
//     return [];
//   }
// }
