import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/classroom_service.dart';

class StudentActivity extends StatefulWidget {
  final String classroomId;
  final String activityId;

  const StudentActivity({
    required this.classroomId,
    required this.activityId,
    super.key,
  });

  @override
  StudentActivityState createState() => StudentActivityState();
}

class StudentActivityState extends State<StudentActivity> {
  final TextEditingController _answerController = TextEditingController();
  final ClassroomService _classroomService = ClassroomService();

  Future<void> _submitAnswer() async {
    String answer = _answerController.text.trim();
    String studentId = FirebaseAuth.instance.currentUser!.uid;

    // Generate a unique submission ID (e.g., timestamp-based)
    String submissionId = DateTime.now().millisecondsSinceEpoch.toString();

    // Convert the student's answer into a Map<String, dynamic> structure
    // that matches your Firestore "statement" fields. For simplicity, store it under "answer":
    final Map<String, dynamic> answerStatement = {
      "answer": answer,
    };

    // For now, let's set correctCells = 0 (or any logic you prefer)
    int correctCells = 0;

    try {
      await _classroomService.submitAnswer(
        submissionId: submissionId,
        activityId: widget.activityId,
        studentId: studentId,
        answerStatement: answerStatement,
        correctCells: correctCells,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Answer Submitted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting answer: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
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
            const SizedBox(height: 16),
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
