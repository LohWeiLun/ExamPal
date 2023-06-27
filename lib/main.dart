
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'Constants/theme.dart';
import 'Constants/theme_services.dart';
import 'Pages/home_page.dart';
import 'Pages/login_page.dart';
import 'Pages/schedule_page.dart';
import 'Pages/signup_page.dart';
import 'Pages/timer_page.dart';

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
      home: HomePage(),
      //home: LoginPage(),
      //home: SignUpPage(),
      //home: TimerPage(),
      //home: SchedulePage(),
    );
  }
}

