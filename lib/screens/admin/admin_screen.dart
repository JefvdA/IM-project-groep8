// ignore_for_file: file_names

import 'package:examap/screens/admin/local_widgets/add_student_tab.dart';
import 'package:examap/screens/admin/local_widgets/change_password_tab.dart';
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final List<Widget> _items = [
    const AddStudentsTab(),
    const ChangePasswordTab(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: globalAppBar,
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _items,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Studenten toevoegen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Wachtwoord wijzigen',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
