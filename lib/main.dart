import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:exampal/Pages/Figma/fastnotepage.dart';
import 'package:exampal/Pages/Figma/homepage.dart';
import 'package:exampal/Pages/Login/backupSignUp.dart';
import 'package:exampal/Pages/Notes/FileConversion_page.dart';
import 'package:exampal/Pages/activity_page.dart';
import 'package:exampal/Pages/community_page.dart';
import 'package:exampal/Pages/friendlist_page.dart';
import 'package:exampal/Pages/Notes/noteSummarization.dart';
import 'package:exampal/Pages/UserProfile/profile_page.dart';
import 'package:exampal/Pages/Notes/recentnotes.dart';
import 'package:exampal/Pages/UserProfile/settings.dart';
import 'package:exampal/Pages/Login/updated_homepage.dart';
import 'package:exampal/Pages/Login/updated_loginpage.dart';
import 'package:exampal/Pages/Login/updated_signuppage.dart';
import 'package:exampal/Pages/Voice-ToText/voicetotext.dart';
import 'package:exampal/Pages/Figma/fastnotepage.dart';
import 'package:exampal/Providers/user_provider.dart';
import 'package:exampal/Responsive/mobile_screen_layout.dart';
import 'package:exampal/Screens/add_post_screen.dart';
import 'package:exampal/Screens/feed_screen.dart';
import 'package:exampal/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:exampal/Constants/colors.dart';
import 'Constants/theme.dart';
import 'Constants/theme_services.dart';
import 'Pages/Voice-ToText/voicetotextpage.dart';
import 'Pages/Figma/fastnotepage.dart';
import 'Pages/Timetable/schedule_page.dart';
import 'Pages/Timetable/timer_page.dart';
import 'Pages/Login/forgotpassword_page.dart';
import 'Pages/Notes/imagetopdf_page.dart';
import 'Pages/Figma/homepage.dart';
import 'Pages/Friends/Screen/friends_homepage.dart';
import 'Pages/Friends/Screen/friends_homepagescreen.dart';
import 'Pages/Friends/Screen/cameraScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'Notifications/notification_services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
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
        /*Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
         */
        //home: UpdatedHomePage(),
        //home: ForgotPasswordPage(),
        //home: RootPage(),
        //home: AddPostScreen(),
        //home: FriendsHomescreen(),
        //home: FeedScreen(),

        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return UpdatedHomePage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return SignInPage();
          },
        ),

        //home: Homepage(),
        //home: NoteSummarizationPage(),
        //home: VoiceToText(),
        //home: SettingsPage(),
        //home: FastNoteFunctionPage(),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> _tabItems = [TimerPage(), Homepage(), ProfilePage()];
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabItems[_activePage],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xffecf1f2),
        color: const Color(0xffc1e1e9),
        animationDuration: const Duration(milliseconds: 300),
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
