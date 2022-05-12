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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: const Text(
              "Afmelden",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                width: 400,
                height: 30,
                child: TextField(
                  maxLines: 1,
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Oud Wachtwoord",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
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
                    labelText: "Nieuw wachtwoord",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
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
                    labelText: "Bevestig nieuw wachtwoord",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
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
                child: const Text(
                  "Wachtwoord wijzigen",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
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
        _message = "Nieuwe wachtwoorden komen niet overeen";
        _messageStyle = const TextStyle(
          color: Colors.red,
        );
      });
      return;
    }

    auth.changePassword(oldPassword, newPassword).then((String? response) {
      if (response == "SUCCES") {
        setState(() {
          _message = "Wachtwoord succesvol veranderd";
          _messageStyle = const TextStyle(
            color: Colors.green,
          );
        });
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else if (response == "Wachtwoord moet minimaal 6 tekens lang zijn") {
        setState(() {
          _message = "Wachtwoord moet minimaal 6 tekens lang zijn";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
      } else if (response ==
          "Het wachtwoord is ongeldig of de gebruiker heeft geen wachtwoord.") {
        setState(() {
          _message = "Het oude wachtwoord is ongeldig";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
      } else {
        setState(() {
          _message = "Veranderen van wachtwoord mislukt";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
      }
    });
  }
}
