import 'package:examap/screens/admin/admin_screen.dart';
import 'package:examap/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminUser = context.watch<User?>();

    if (adminUser != null) {
      return const AdminScreen();
    }

    return const HomeScreen();
  }
}
