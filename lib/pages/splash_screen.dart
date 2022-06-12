import 'package:car_rental_app_ui/pages/login_screen.dart';
import 'package:car_rental_app_ui/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2) , () {
      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                  height: 400,
                  child: Image.asset(
                    "assets/icons/SobGOGdark.png",
                    fit: BoxFit.contain,
                  )),
            ),

          ],
        ),
      ),
    );
  }
}
