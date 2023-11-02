
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:exampal/Pages/FileConversion_page.dart';
import 'package:exampal/Pages/activity_page.dart';
import 'package:exampal/Pages/community_page.dart';
import 'package:exampal/Pages/friendlist_page.dart';
import 'package:exampal/Pages/profile_page.dart';
import 'package:exampal/Pages/recentnotes.dart';
import 'package:exampal/Pages/updated_homepage.dart';
import 'package:exampal/Pages/updated_loginpage.dart';
import 'package:exampal/Pages/updated_signuppage.dart';
import 'package:exampal/Pages/voicetotext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';


import 'Constants/theme.dart';
import 'Constants/theme_services.dart';
import 'Pages/home_page.dart';
import 'Pages/schedule_page.dart';
import 'Pages/timer_page.dart';
import 'Pages/forgotpassword_page.dart';
import 'Pages/imagetopdf_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExamPal',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      //home: HomePage(),
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
      home: SignInPage(),
      //home: UpdatedSignUpPage(),
      //home: UpdatedHomePage(),
      //home: ForgotPasswordPage(),
      //home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>{
  final List<Widget> _tabItems = [TimerPage(), HomePage(), ProfilePage()];
  int _activePage = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _tabItems[_activePage],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xffecf1f2),
        color: const Color(0xffc1e1e9),
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index){
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



