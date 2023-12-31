import 'dart:async';

import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:exampal/Pages/Figma/chatPDF.dart';
import 'package:exampal/Pages/Figma/homepage.dart';
import 'package:exampal/Pages/FileConversion/FileConversionPage.dart';
import 'package:exampal/Pages/Login/updated_homepage.dart';
import 'package:exampal/Pages/Login/updated_loginpage.dart';
import 'package:exampal/Pages/UserProfile/profile_page.dart';
import 'package:exampal/Pages/Voice-ToText/voiceToTextFunction.dart';
import 'package:exampal/Providers/user_provider.dart';
import 'package:exampal/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'Notifications/notification_services.dart';
import 'Pages/ChatGPT/providers/chats_providers.dart';
import 'Pages/ChatGPT/providers/models_provider.dart';
import 'Pages/Community/community_mainpage.dart';
import 'Pages/Figma/testFastNote.dart';
import 'Pages/Timetable/timer_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  tz.setLocalLocation(tz.local);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ExamPal',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 1,
            color: Colors.blue,
          ),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<String>(
          future: _getInitialRoute(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Builder(
                builder: (BuildContext context) {
                  return _buildPage(context, snapshot.data!);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, String initialRoute) {
    return initialRoute == '/' ? const RootPage() : SignInPage();
  }

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('rememberedEmail');
    return userId != null ? '/' : '/signin';
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> _tabItems = [
    CommunityPage(),
    Homepage(),
    ProfilePage(),
  ];
  int _activePage = 1;

  @override
  void initState() {
    super.initState();
    _activePage = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabItems[_activePage],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xffc1e1e9),
        animationDuration: const Duration(milliseconds: 300),
        index: 1,
        onTap: (index) {
          setState(() {
            _activePage = index;
          });
        },
        items: const [
          Icon(
            Icons.group,
            color: Colors.black87,
          ),
          Icon(
            Icons.add,
            color: Colors.black87,
          ),
          Icon(
            Icons.person,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}


// import 'package:exampal/Pages/ChatGPT/providers/chats_providers.dart';
// import 'package:exampal/Pages/ChatGPT/providers/models_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'Pages/ChatGPT/chat_screen.dart';
// import 'Pages/ChatGPT/constants/constants.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => ModelsProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => ChatProvider(),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Flutter ChatBOT',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//             scaffoldBackgroundColor: scaffoldBackgroundColor,
//             appBarTheme: AppBarTheme(
//               color: cardColor,
//             )),
//         home: const ChatScreen(),
//       ),
//     );
//   }
// }
