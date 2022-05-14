import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class EditQuestionsScreen extends StatefulWidget {
  const EditQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<EditQuestionsScreen> createState() => _EditQuestionsScreenState();
}

class _EditQuestionsScreenState extends State<EditQuestionsScreen> {

  final CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ],
        ),
      ),
    );
  }

  Widget _buildEditQuestionForm(BuildContext context) {
    // if (_selectedValue == "OQ") {
    //   return OpenQuestionForm(widget.examId, widget.questionId);
    // } else if (_selectedValue == "MC") {
    //   return MultipleChoiceForm(widget.examId, widget.questionId);
    // } else if (_selectedValue == "CC") {
    //   return CodeCorrectionForm(widget.examId, widget.questionId);
    // }
    return Container();
  }
}