// import 'package:exampal/Pages/Timetable/schedule_generator.dart';
// import 'package:exampal/Pages/Timetable/schedule_mainpage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../Widgets/todo_list_item.dart';
//
// class ScheduleDetailsPage extends StatefulWidget {
//   final String scheduleId;
//
//   const ScheduleDetailsPage({Key? key, required this.scheduleId})
//       : super(key: key);
//
//   @override
//   _ScheduleDetailsPageState createState() => _ScheduleDetailsPageState();
// }
//
// class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
//   late List<Map<String, dynamic>> tasks;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchScheduleDetails();
//   }
//
//   Future<void> fetchScheduleDetails() async {
//     try {
//       // Fetch schedule details using the scheduleId
//       DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//       await FirebaseFirestore.instance
//           .collection("user")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection("schedule")
//           .doc(widget.scheduleId)
//           .get();
//
//       // Get the 'schedule' array from the document
//       List<dynamic> schedule = documentSnapshot.data()?['schedule'] ?? [];
//
//       // Convert the schedule array to a list of tasks
//       tasks = List<Map<String, dynamic>>.from(schedule);
//
//       // Trigger a rebuild of the widget
//       setState(() {});
//     } catch (error) {
//       // Handle errors
//       print('Error fetching schedule details: $error');
//       // Initialize tasks to an empty list in case of an error
//       tasks = [];
//     }
//   }
//
//   Future<void> deleteSchedule() async {
//     try {
//       // Delete the schedule from Firestore
//       await FirebaseFirestore.instance
//           .collection("user")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection("schedule")
//           .doc(widget.scheduleId)
//           .delete();
//
//       // Navigate to the schedule page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SchedulePage(), // Replace SchedulePage with your actual schedule page
//         ),
//       );
//     } catch (error) {
//       // Handle errors
//       print('Error deleting schedule: $error');
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Schedule Details'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20.0),
//             child: GestureDetector(
//               onTap: () {
//                 // Show delete confirmation dialog
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text('Confirm Deletion'),
//                       content: const Text(
//                           'Are you sure you want to delete this schedule?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             // Close the dialog
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             // Delete the schedule
//                             deleteSchedule();
//                           },
//                           child: const Text('Confirm'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               child: const Icon(Icons.delete),
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         child: tasks.isNotEmpty
//             ? ListView.builder(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 20.0,
//             vertical: 10.0,
//           ),
//           itemCount: tasks.length,
//           itemBuilder: (context, index) {
//             DateTime sessionDate = tasks[index]['date'].toDate();
//             String formattedDate =
//                 '${sessionDate.day}-${sessionDate.month}-${sessionDate.year}';
//             String text =
//                 '$formattedDate   ${tasks[index]['topic']} - ${tasks[index]['duration']} hours';
//
//             return TodoListItem(
//               text: text,
//               isChecked: tasks[index]['complete'],
//               onPress: () async {
//                 // Update task status
//                 ScheduleGenerator.updateTaskStatus(
//                   widget.scheduleId,
//                   index,
//                   !tasks[index]['complete'],
//                 );
//                 // Fetch updated schedule details
//                 await fetchScheduleDetails();
//               },
//               id: widget.scheduleId,
//               index: index,
//             );
//           },
//         )
//             : const Text('No tasks in this schedule'),
//       ),
//     );
//   }
// }
