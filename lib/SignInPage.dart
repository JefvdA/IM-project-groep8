// ignore_for_file: file_names

import 'package:examap/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signinpage extends StatelessWidget {
  Signinpage({ Key? key }) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 250),
                const Text(
                  'Login als lector:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 1000,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: 1000,
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signIn(
                      email: emailController.text.trim(), 
                      password: passwordController.text.trim()
                    );
                  }, 
                  child: const Text("Log in"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}