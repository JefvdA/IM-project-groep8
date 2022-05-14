import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/edit_questions/local_widgets/edit_code_correction.dart';
import 'package:examap/screens/edit_questions/local_widgets/edit_multiple_choice.dart';
import 'package:examap/screens/edit_questions/local_widgets/edit_open_question_form.dart';
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class EditQuestionsScreen extends StatefulWidget {
  final String examId;
  final String questionId;
  final LinkedHashMap<String, dynamic> question;
  const EditQuestionsScreen(this.examId, this.questionId, this.question, {Key? key}) : super(key: key);

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
            if(widget.question['type'] == 'OQ')
              EditOpenQuestionForm(widget.examId, widget.questionId, widget.question)
            else if(widget.question['type'] == 'MC')
              EditMultipleChoiceForm(widget.examId, widget.questionId, widget.question)
            else if(widget.question['type'] == 'CC')
              EditCodeCorrectionForm(widget.examId, widget.questionId, widget.question)
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