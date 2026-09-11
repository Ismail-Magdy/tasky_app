import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/features/auth/screens/on_boarding_screen.dart';
import 'package:tasky_app/features/home/screens/home_screen.dart';
import 'package:tasky_app/features/home/screens/task_details_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'package:tasky_app/features/auth/screens/register_screen.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? const OnboardingScreen()
          : const HomeScreen(),

      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        TaskDetailsScreen.routeName: (context) => const TaskDetailsScreen(),
      },
    );
  }
}
