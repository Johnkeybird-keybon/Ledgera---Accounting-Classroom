import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ledgeroom/screens/classroom_details.dart';
import '../services/classroom_service.dart';

class EnrolledScreen extends StatefulWidget {
  const EnrolledScreen({super.key});

  @override
  EnrolledScreenState createState() => EnrolledScreenState();
}

class EnrolledScreenState extends State<EnrolledScreen> {
  final ClassroomService classroomService = ClassroomService();
  final TextEditingController _codeController = TextEditingController();

  Future<void> _joinClassroom() async {
    String code = _codeController.text;
    if (code.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid classroom code')),
      );
      return;
    }
    String studentId = FirebaseAuth.instance.currentUser!.uid;

    try {
      var classroomSnapshot =
          await classroomService.getClassroomByCode(code).first;
      if (classroomSnapshot != null && classroomSnapshot.exists) {
        String classroomId = classroomSnapshot.id;
        await classroomService.addStudentToClassroom(classroomId, studentId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Joined Classroom Successfully!')),
          );
          setState(() {
            _codeController.clear();
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Classroom Code')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error joining classroom: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolled Classes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Classroom Code',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _joinClassroom,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: classroomService.getClassroomsForStudent(
                  FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                debugPrint('StreamBuilder called');
                if (!snapshot.hasData) {
                  debugPrint('No data available');
                  return const Center(child: CircularProgressIndicator());
                }

                var classrooms = snapshot.data!.docs;

                if (classrooms.isEmpty) {
                  debugPrint('No classrooms found for student');
                  return const Center(
                      child: Text('No enrolled classes found.'));
                }

                return ListView.builder(
                  itemCount: classrooms.length,
                  itemBuilder: (context, index) {
                    var classroom = classrooms[index];
                    debugPrint('Classroom found: ${classroom['className']}');
                    return ListTile(
                      title: Text(classroom['className']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassroomDetails(
                              classroomId: classroom.id,
                              classroomName: classroom['className'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
