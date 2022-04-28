// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("AdminHomePage"),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              }, 
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}