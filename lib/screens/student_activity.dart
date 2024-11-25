import 'package:flutter/material.dart';
import '../services/classroom_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentActivity extends StatefulWidget {
  final String classroomId;
  final String activityId;

  const StudentActivity(
      {required this.classroomId, required this.activityId, super.key});

  @override
  StudentActivityState createState() => StudentActivityState();
}

class StudentActivityState extends State<StudentActivity> {
  final TextEditingController _answerController = TextEditingController();
  final ClassroomService _classroomService = ClassroomService();

  Future<void> _submitAnswer() async {
    String answer = _answerController.text;
    String studentId = FirebaseAuth.instance.currentUser!.uid;

    await _classroomService.submitAnswer(
        widget.classroomId, widget.activityId, studentId, answer);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answer Submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Answer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
              ),
            ),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
