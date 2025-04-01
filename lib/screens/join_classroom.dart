import 'package:flutter/material.dart';
import '../services/classroom_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinClassroom extends StatefulWidget {
  const JoinClassroom({super.key});

  @override
  JoinClassroomState createState() => JoinClassroomState();
}

class JoinClassroomState extends State<JoinClassroom> {
  final TextEditingController _codeController = TextEditingController();
  final ClassroomService _classroomService = ClassroomService();

  Future<void> _joinClassroom() async {
    String code = _codeController.text;
    String studentId = FirebaseAuth.instance.currentUser!.uid;

    _classroomService
        .getClassroomByCode(code)
        .listen((classroomSnapshot) async {
      if (classroomSnapshot!.exists) {
        String classroomId = classroomSnapshot.id;
        await _classroomService.addStudentToClassroom(classroomId, studentId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Joined Classroom Successfully!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Classroom Code')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Classroom'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Classroom Code',
              ),
            ),
            ElevatedButton(
              onPressed: _joinClassroom,
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
