import 'package:car_rental_app_ui/data/themes_data.dart';
import 'package:car_rental_app_ui/pages/home_page.dart';
import 'package:car_rental_app_ui/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_rental_app_ui/pages/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
      title: 'Car Rental App',
      home: const LoginScreen(),
      theme: lightModeTheme,
      darkTheme: darkModeTheme,
    );
  }
}
