// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:examap/services/authentication_service.dart';

class ChangePasswordTab extends StatefulWidget {
  const ChangePasswordTab({Key? key}) : super(key: key);

  @override
  State<ChangePasswordTab> createState() => _ChangePasswordTabState();
}

class _ChangePasswordTabState extends State<ChangePasswordTab> {
  String _message = "";
  TextStyle _messageStyle = const TextStyle(
    color: Colors.green,
  );

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: const Text("Uitloggen"),
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
                    labelText: "Oude wachtwoord",
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
                    labelText: "Nieuwe wachtwoord",
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
                    labelText: "Bevestig nieuwe wachtwoord",
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
                child: const Text("Verander wachtwoord"),
              ),
              Text(_message, style: _messageStyle),
            ],
          ),
        )
      ],
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
      } else if (response == "Password should be at least 6 characters") {
        setState(() {
          _message = "Password should be at least 6 characters";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
      } else if (response ==
          "The password is invalid or the user does not have a password.") {
        setState(() {
          _message = "The old password is invalid";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
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
}
