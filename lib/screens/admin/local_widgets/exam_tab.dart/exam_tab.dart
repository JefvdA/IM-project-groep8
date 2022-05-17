import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/add_questions/add_questions_screen.dart';
import 'package:examap/screens/admin/local_widgets/add_exam_screen.dart';
import 'package:flutter/material.dart';

class ExamTab extends StatefulWidget {
  const ExamTab({Key? key}) : super(key: key);

  @override
  State<ExamTab> createState() => _ExamTabState();
}

class _ExamTabState extends State<ExamTab> {

  bool isExamLoaded = false;
  late QueryDocumentSnapshot exam;

  final CollectionReference examsCollection =
    FirebaseFirestore.instance.collection('exams');

  @override
  void initState() {
    super.initState();

    loadExam();
  }

  void loadExam() async {
    bool examExists = await checkExamExists();
    if(!examExists){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AddExamScreen(),
        ),
      );
    } else {
      QuerySnapshot examSnapshot = await examsCollection.get();
      setState(() {
        exam = examSnapshot.docs.first;
        isExamLoaded = true;
      });
    }
  }

  Future<bool> checkExamExists() async {
    QuerySnapshot examSnapshot = await examsCollection.get();
    return examSnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return isExamLoaded 
    ?
       AddQuestionsScreen(exam.get('name'))
    :
      const Center(
        child: CircularProgressIndicator(),
      );
  }
}