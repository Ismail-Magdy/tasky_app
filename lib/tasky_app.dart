import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/features/auth/screens/on_boarding_screen.dart';
import 'package:tasky_app/features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'package:tasky_app/features/auth/screens/register_screen.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FirebaseAuth.instance.currentUser == null
          ? OnboardingScreen()
          : HomeScreen(),

      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
      },
    );
  }
}
