import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:exampal/Pages/Figma/fastnotepage.dart';
import 'package:exampal/Pages/Figma/homepage.dart';
import 'package:exampal/Pages/FileConversion_page.dart';
import 'package:exampal/Pages/activity_page.dart';
import 'package:exampal/Pages/community_page.dart';
import 'package:exampal/Pages/friendlist_page.dart';
import 'package:exampal/Pages/noteSummarization.dart';
import 'package:exampal/Pages/profile_page.dart';
import 'package:exampal/Pages/recentnotes.dart';
import 'package:exampal/Pages/settings.dart';
import 'package:exampal/Pages/updated_homepage.dart';
import 'package:exampal/Pages/updated_loginpage.dart';
import 'package:exampal/Pages/updated_signuppage.dart';
import 'package:exampal/Pages/voicetotext.dart';
import 'package:exampal/Pages/Figma/fastnotepage.dart';
import 'package:exampal/Responsive/mobile_screen_layout.dart';
import 'package:exampal/Screens/feed_screen.dart';
import 'package:exampal/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'package:exampal/Constants/colors.dart';
import 'Constants/theme.dart';
import 'Constants/theme_services.dart';
import 'Pages/Figma/voicetotextpage.dart';
import 'Pages/Figma/fastnotepage.dart';
import 'Pages/schedule_page.dart';
import 'Pages/timer_page.dart';
import 'Pages/forgotpassword_page.dart';
import 'Pages/imagetopdf_page.dart';
import 'Pages/Figma/homepage.dart';
import 'Pages/Friends/Screen/friends_homepage.dart';
import 'Pages/Friends/Screen/friends_homepagescreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      //home: Homepage(),
      //home: RecentFilesPage(),
      //home: TimerPage(),
      //home: ImageToPdf(),
      //home: SchedulePage(),
      //home: ProfilePage(),
      //home: const RootPage(),
      //home: FileConversionPage(),
      //home: ActivityPage(),
      //home: CommunityPage(),
      //home: FriendsListPage(),
      //home: FastNotePage(),
      //home: VoiceToTextPage(),
      /*
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Homepage();
          } else {
            return SignInPage();
          }
        },
      ),
      */
      //home: UpdatedSignUpPage(),
      //home: UpdatedHomePage(),
      //home: ForgotPasswordPage(),
      //home: RootPage(),
      //home: AddPostScreen(),
      home: FriendsHomescreen(),
      //home: NoteSummarizationPage(),
      //home: VoiceToText(),
      //home: SettingsPage(),
      //home: FastNoteFunctionPage(),
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
