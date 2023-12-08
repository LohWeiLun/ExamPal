import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exampal/Pages/Login/updated_loginpage.dart';
import 'package:exampal/Pages/UserProfile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../../Notifications/notification_services.dart';

DateTime scheduleTime = DateTime.now();
TimeOfDay time = TimeOfDay.now();

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool scheduleN = false;
  bool communityN = false;
  bool motivationN = false;
  bool theme = false;

  String themeName = "Light";
  String email = "";
  String uid = "";
  String? mtoken = " ";
  late List<Map<String, dynamic>> todaysTasks = [];

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          scheduleN = snapshot.data()!["scheduleN"];
          communityN = snapshot.data()!["communityN"];
          motivationN = snapshot.data()!["motivationN"];
          theme = snapshot.data()!["theme"];
          email = snapshot.data()!["email"];
          uid = snapshot.data()!["uid"];
        });
      }
    });

    if (motivationN) {
      FirebaseMessaging.instance.subscribeToTopic("Motivation");
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("Motivation");
    }

    if (scheduleN) {
      FirebaseMessaging.instance.subscribeToTopic("Schedule");
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("Schedule");
    }

    if (communityN) {
      FirebaseMessaging.instance.subscribeToTopic("Community");
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("Community");
    }
  }

  Future<void> _updateUserSettings() async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'scheduleN': scheduleN,
        'communityN': communityN,
        'motivationN': motivationN,
        'theme': theme,
      });

      // Fetch updated data if needed
      await _getDataFromDatabase();
    } catch (error) {
      // Handle errors
      print('Error updating user settings: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
    fetchTodayTasks();
  }


  Future<void> fetchTodayTasks() async {
    try {
      // Fetch today's tasks
      todaysTasks = await getTodaysTasks();

      // Trigger a rebuild of the widget
      setState(() {});
    } catch (error) {
      // Handle errors
      print('Error fetching data: $error');
      // Initialize scheduleList to an empty list in case of an error
      todaysTasks = [];
    }
  }


  void getTokenFromFirestore() async {}

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc(uid).set({
      'token': token,
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA9xPglTQ:APA91bEuI1Hg2Mw6dLpBuh2bDvJfgcYOUm_rEUhq3glaPRzICYtTUQEG6iFF1r_EeWx3B_wC9sTDVxk0x1PYgcSh-N9Di4qG-GNF3LVDjhc9F5B_cfEqvdky-Rc1ILwdAc1oqtB5Ho8v',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.grey,
        elevation: 1,
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
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Reset password"),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const ProfilePage();
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                String oldPassword = '';
                String newPassword = '';
                String confirmPassword = '';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Change Password'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            obscureText: true,
                            onChanged: (value) {
                              oldPassword = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Old Password',
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            onChanged: (value) {
                              newPassword = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'New Password',
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            onChanged: (value) {
                              confirmPassword = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              // Check if new password matches confirm password
                              if (newPassword != confirmPassword) {
                                throw 'New passwords do not match.';
                              }

                              // Reauthenticate the user with their current credentials
                              AuthCredential credential = EmailAuthProvider.credential(
                                email: FirebaseAuth.instance.currentUser!.email!,
                                password: oldPassword,
                              );

                              await FirebaseAuth.instance.currentUser!
                                  .reauthenticateWithCredential(credential);

                              // Update the password using FirebaseAuth
                              await FirebaseAuth.instance.currentUser!
                                  .updatePassword(newPassword);

                              Navigator.of(context).pop(); // Close dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password changed successfully')),
                              );
                            } catch (error) {
                              print('Error changing password: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password change failed')),
                              );
                            }
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Motivation Notifications",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: motivationN,
                      activeColor: Colors.grey,
                      onChanged: (bool newBool) {
                        setState(() {
                          motivationN = newBool;
                        });
                        if (motivationN) {
                          FirebaseMessaging.instance
                              .subscribeToTopic("Motivation");
                        } else {
                          FirebaseMessaging.instance
                              .unsubscribeFromTopic("Motivation");
                        }
                        _updateUserSettings();
                      },
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Schedule Notifications",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: scheduleN,
                      activeColor: Colors.grey,
                      onChanged: (bool newBool) {
                        setState(() {
                          scheduleN = newBool;
                          FirebaseMessaging.instance.subscribeToTopic("Schedule");
                          _updateUserSettings();
                        });
                      },
                    ))
              ],
            ),
            Visibility(
              visible: (scheduleN), // condition here
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DatePickerTxt(),
                ],
              ),
            ),
            Visibility(
              visible: (scheduleN), // condition here
              child: ElevatedButton(
                child: const Text('Schedule notifications'),
                onPressed: () {
                  int tasks = todaysTasks.length;
                  debugPrint('Notification Scheduled for $scheduleTime');
                  NotificationService().scheduleNotification(
                    title: 'Schedule',
                    body: 'You Have $tasks Tasks in your To-Do List!',
                    scheduledNotificationDateTime: scheduleTime,
                  );
                },
              ),
            ),
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Community Notifications",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: communityN,
                      activeColor: Colors.grey,
                      onChanged: (bool newBool) {
                        setState(() {
                          communityN = newBool;
                        });
                      },
                    ))
              ],
            ),
             */
            const SizedBox(
              height: 40,
            ),
            const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Theme",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  themeName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: theme,
                      activeColor: Colors.grey,
                      onChanged: (bool newBool) {
                        setState(() {
                          theme = newBool;
                          _updateUserSettings();
                        });
                      },
                    ))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sign Out'),
                        content: Text('Are you sure you want to sign out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Return false on cancel
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Return true on confirmation
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  ).then((value) {
                    if (value != null && value) {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    }
                  });
                },
                child: const Text("SIGN OUT",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              activeColor: Colors.grey,
              onChanged: (bool newBool) {
                setState(() {
                  isActive = newBool;
                });
              },
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("user")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                          String userEmail = data['email'];

                          return Text("Send an email to $userEmail to reset password?");
                        }

                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("CANCEL")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        resetPassword();
                      },
                      child: const Text("OK")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

      const snackBar = SnackBar(
        content: Text('Password Reset Email Sent'),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
    }
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class TimePickerTxt extends StatefulWidget {
  const TimePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<TimePickerTxt> createState() => _TimePickerTxtState();
}

class _TimePickerTxtState extends State<TimePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        TimeOfDay selectedTime = showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
        ) as TimeOfDay;
        time = selectedTime;
      },
      child: const Text(
        'Select Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
          title: 'Scheduled Notification',
          body: '$scheduleTime',
          scheduledNotificationDateTime: scheduleTime,
        );
      },
    );
  }
}

Future<List<Map<String, dynamic>>> getTodaysTasks() async {
  try {
    // Fetch schedules for the user from Firebase Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("schedule")
        .get();

    List<Map<String, dynamic>> todaysTasks = [];

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
    in querySnapshot.docs) {
      List<dynamic> schedule = doc['schedule'] ?? [];

      for (Map<String, dynamic> session in schedule) {
        DateTime sessionDate = (session['date'] as Timestamp).toDate();

        // Check if the session is for today
        if (sessionDate.isAtSameMomentAs(today) || sessionDate.isAfter(today) && sessionDate.isBefore(tomorrow)) {
          // Add the session data to todaysTasks
          Map<String, dynamic> taskData = {
            'scheduleId': doc.id,
            'sessionIndex': schedule.indexOf(session),
            ...session,
          };
          todaysTasks.add(taskData);
        }
      }
    }
    print(todaysTasks);
    return todaysTasks;
  } catch (error) {
    print('Error fetching todaysTasks: $error');
    return [];
  }
}
