// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/admin/local_widgets/add_student_tab.dart';
import 'package:examap/screens/admin/local_widgets/change_password_tab.dart';
import 'package:examap/screens/admin/local_widgets/exam_tab.dart/exam_tab.dart';
import 'package:examap/screens/admin/local_widgets/grade_exam_tab.dart';
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  bool doesExamExist = false;

  final CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');

  List<Widget> _items = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    checkExamExists();

    _items = [
      const AddStudentsTab(),
      const ChangePasswordTab(),
      ExamTab(checkExamExists),
      const GradeExamTab()
    ];
  }

  void checkExamExists() async {
    QuerySnapshot examSnapshot = await examsCollection.get();
    setState(() {
      doesExamExist = examSnapshot.docs.isNotEmpty;
    });
  }

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
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Studenten toevoegen',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Wachtwoord wijzigen',
          ),
          doesExamExist
              ? const BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Vragen teoevoegen',
                )
              : const BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Examen aanmaken',
                ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.grading_rounded), label: 'Beoordelen'),
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
