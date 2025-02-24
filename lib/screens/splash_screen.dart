import 'package:employee_attendance_app/screens/home_screen.dart';
import 'package:employee_attendance_app/screens/login_screen.dart';
import 'package:employee_attendance_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

   // authService.signOut();
    return authService.currentUser  == null ? LogInScreen():HomeScreen();
  }
}
