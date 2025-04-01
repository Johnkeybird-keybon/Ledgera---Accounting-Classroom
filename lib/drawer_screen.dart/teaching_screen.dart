import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/classroom_service.dart';
import 'package:ledgeroom/screens/classroom_details.dart';
import 'package:ledgeroom/screens/add_classroom.dart';

class TeachingScreen extends StatefulWidget {
  const TeachingScreen({super.key});

  @override
  TeachingScreenState createState() => TeachingScreenState();
}

class TeachingScreenState extends State<TeachingScreen> {
  final ClassroomService classroomService = ClassroomService();

  @override
  Widget build(BuildContext context) {
    // Retrieve teacher's UID from FirebaseAuth
    String teacherId = FirebaseAuth.instance.currentUser?.uid ?? '';
    debugPrint("Current Teacher UID: $teacherId");

    if (teacherId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Error: Teacher ID not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teaching Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: classroomService.getClassroomsForTeacher(teacherId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            debugPrint("No classrooms found for teacher with UID: $teacherId");
            return const Center(
              child: Text("No classroom found"),
            );
          }

          var classrooms = snapshot.data!.docs;
          debugPrint("Found ${classrooms.length} classrooms for teacher.");

          return ListView.builder(
            itemCount: classrooms.length,
            itemBuilder: (context, index) {
              var classroom = classrooms[index].data() as Map<String, dynamic>;
              debugPrint(
                  "Classroom ${index + 1}: ${classroom['className']} - Teacher: ${classroom['teacherId']}");
              return ListTile(
                title: Text(classroom['className'] ?? "No Name"),
                subtitle: Text('Teacher: ${classroom['teacherId']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassroomDetails(
                        classroomId: classrooms[index].id,
                        classroomName: classroom['className'] ?? "",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddClassroom screen to create a new classroom.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddClassroom(),
            ),
          );
        },
        tooltip: 'Create Class',
        child: const Icon(Icons.add),
      ),
    );
  }
}
