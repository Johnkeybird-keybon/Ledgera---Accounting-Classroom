import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ledgeroom/screens/add_classroom.dart';
import 'package:ledgeroom/screens/classroom_details.dart'; // Import ClassroomDetails
import '../services/classroom_service.dart';

class TeachingScreen extends StatefulWidget {
  const TeachingScreen({super.key});

  @override
  TeachingScreenState createState() => TeachingScreenState();
}

class TeachingScreenState extends State<TeachingScreen> {
  final ClassroomService classroomService = ClassroomService();

  @override
  Widget build(BuildContext context) {
    String teacherId = 'teacherId'; // Replace with the actual teacher ID

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
            return const Center(child: Text('No classrooms found.'));
          }

          var classrooms = snapshot.data!.docs;
          debugPrint(
              'Number of classrooms: ${classrooms.length}'); // Debug print

          return ListView.builder(
            itemCount: classrooms.length,
            itemBuilder: (context, index) {
              var classroom = classrooms[index];
              debugPrint(
                  'Classroom name: ${classroom['className']}'); // Debug print
              return ListTile(
                title: Text(classroom['className']),
                subtitle: Text('Teacher: ${classroom['teacherId']}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
