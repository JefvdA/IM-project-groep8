// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({ Key? key }) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String _message = "";
  TextStyle _messageStyle = const TextStyle(
    color: Colors.green,
  );

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: const Text("Sign out"),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  width: 400,
                  height: 30,
                  child: TextField(
                    maxLines: 1,
                    controller: oldPasswordController,
                    decoration: const InputDecoration(
                      labelText: "Old password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  width: 400,
                  height: 30,
                  child: TextField(
                    maxLines: 1,
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      labelText: "New password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  width: 400,
                  height: 30,
                  child: TextField(
                    maxLines: 1,
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: "Confirm new password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _changePassword();
                  },
                  child: const Text("Change password"),
                ),
                Text(
                  _message,
                  style: _messageStyle
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _changePassword() {
    final AuthenticationService auth = context.read<AuthenticationService>();
    final String oldPassword = oldPasswordController.text;
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() {
        _message = "New passwords do not match";
        _messageStyle = const TextStyle(
          color: Colors.red,
        );
      });
      return;
    }

    auth.changePassword(oldPassword, newPassword).then((String? response) {
      if (response == "SUCCES") {
        setState(() {
          _message = "Password changed successfully";
          _messageStyle = const TextStyle(
            color: Colors.green,
          );
        });
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        setState(() {
          _message = "Password change failed";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
      }
    });
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  void _styleMessage(TextStyle style){
    setState(() {
      _messageStyle = style;
    });
  }
}