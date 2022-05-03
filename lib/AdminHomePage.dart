// ignore_for_file: file_names

import 'package:examap/AddStudentPage.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final List<Widget> _items = [
    const AddStudentPage(),
    const Text('Change password page comming soon...'),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExamAp'),
      ),
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
            label: 'Add student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Change password',
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
