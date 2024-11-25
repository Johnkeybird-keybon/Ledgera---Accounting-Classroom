import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';
import '../services/classroom_service.dart';

class WorksheetTemplate extends StatefulWidget {
  final String classroomId;

  const WorksheetTemplate({required this.classroomId, super.key});

  @override
  WorksheetTemplateState createState() => WorksheetTemplateState();
}

class WorksheetTemplateState extends State<WorksheetTemplate> {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController activityTypeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ClassroomService classroomService = ClassroomService();

  Future<void> _createActivity() async {
    if (companyController.text.isEmpty ||
        activityTypeController.text.isEmpty ||
        dateController.text.isEmpty) {
      return; // Show error message if needed
    }

    String activityName = "Worksheet: ${companyController.text.trim()}";
    String correctAnswer =
        "Correct answer format here"; // Implement correct answer logic
    int points = 0; // Points can be set to 0 or adjusted as needed

    await classroomService.createActivity(
        widget.classroomId, activityName, correctAnswer, points);

    if (mounted) {
      companyController.clear();
      activityTypeController.clear();
      dateController.clear();
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worksheet Template"),
      ),
      body: Zoom(
        initScale: 0.5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: companyController,
                        decoration: const InputDecoration(
                          labelText: 'Company',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: activityTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Activity Type',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _createActivity,
                  child: const Text('Create Activity'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
