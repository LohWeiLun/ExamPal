import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exampal/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  //create instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to initialize notifications
  Future<void> initNotifications() async {

    //request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    //fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    //print the token (normally you would send this to your server)
    print('Token: $fCMToken');

    //store token
    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).set(
    {
    'token':fCMToken,
    },SetOptions(merge:true));

    //initialize further settings for push notifications
    initPushNotifications();
  }

  //function to handle received messages
  void handleMessage(RemoteMessage? message) {
    //if the message is null, do nothing
    if (message == null) return;

    //navigate to new screen when message is received and user taps notification
    navigatorKey?.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

//function to initialize foreground and background settings
  Future initPushNotifications() async {
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
