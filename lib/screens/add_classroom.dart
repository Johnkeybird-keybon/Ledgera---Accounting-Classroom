import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import '../services/classroom_service.dart';

class AddClassroom extends StatefulWidget {
  const AddClassroom({super.key});

  @override
  AddClassroomState createState() => AddClassroomState();
}

class AddClassroomState extends State<AddClassroom> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final ClassroomService _classroomService = ClassroomService();
  String? _generatedCode;

  Future<void> _addClassroom() async {
    String className = _classNameController.text;
    String section = _sectionController.text; // Use the section variable
    String room = _roomController.text;
    String subject = _subjectController.text;
    String teacherId = 'teacherId'; // Replace with the actual teacher ID
    List<String> templates = []; // Add templates as needed

    // Create the classroom and get its reference
    DocumentReference classroomRef = await _classroomService.createClassroom(
        className, teacherId, [], room, subject, templates, section);

    // Fetch the generated code from Firestore to display it
    var createdClassroom = await classroomRef.get();

    if (mounted) {
      setState(() {
        _generatedCode = createdClassroom['code'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _classNameController,
              decoration: const InputDecoration(
                labelText: 'Class Name (required)',
              ),
            ),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(
                labelText: 'Section',
              ),
            ),
            TextField(
              controller: _roomController,
              decoration: const InputDecoration(
                labelText: 'Room',
              ),
            ),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
              ),
            ),
            ElevatedButton(
              onPressed: _addClassroom,
              child: const Text('Create Classroom'),
            ),
            if (_generatedCode != null)
              Column(
                children: [
                  const SizedBox(height: 16.0),
                  Text('Classroom code: $_generatedCode'),
                  ElevatedButton(
                    onPressed: () {
                      if (_generatedCode != null) {
                        Clipboard.setData(ClipboardData(text: _generatedCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Classroom code copied to clipboard')),
                        );
                      }
                    },
                    child: const Text('Copy Code'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
