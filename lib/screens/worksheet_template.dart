import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart'; // to get teacher's UID
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
    // Basic validation
    if (companyController.text.isEmpty ||
        activityTypeController.text.isEmpty ||
        dateController.text.isEmpty) {
      // Show an error message or handle appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    // Generate an activityId
    String activityId = DateTime.now().millisecondsSinceEpoch.toString();

    // Get the teacherId from the current logged-in user
    String teacherId = FirebaseAuth.instance.currentUser!.uid;

    // Title and description for your activity
    String title = "Worksheet: ${companyController.text.trim()}";
    String description =
        "Type: ${activityTypeController.text.trim()} | Date: ${dateController.text.trim()}";

    // For now, let's set all the statement fields to 0 or placeholders
    // You can replace these with real user inputs if desired
    try {
      await classroomService.createActivity(
        activityId: activityId,
        classroomId: widget.classroomId,
        teacherId: teacherId,
        title: title,
        description: description,
        company: companyController.text.trim(),
        period: dateController.text.trim(),
        receiptsFromCustomers: 0,
        paymentsToSuppliersAndEmployees: 0,
        netCashOperating: 0,
        purchasesPropertyEquipment: 0,
        netCashInvesting: 0,
        longTermLoan: 0,
        additionalInvestment: 0,
        withdrawalsByOwner: 0,
        netCashFinancing: 0,
        netIncreaseCash: 0,
        cashBeginning: 0,
        cashEnding: 0,
        totalCells: 12, // Example placeholder
      );

      if (mounted) {
        // Clear the text fields
        companyController.clear();
        activityTypeController.clear();
        dateController.clear();

        // Optionally close the current screen or show a success message
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity Created!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating activity: $e')),
        );
      }
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
                // Company
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                  ),
                ),
                const SizedBox(height: 16.0),

                // Activity Type
                TextField(
                  controller: activityTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Activity Type',
                  ),
                ),
                const SizedBox(height: 16.0),

                // Date
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                ),
                const SizedBox(height: 16.0),

                // Create Activity Button
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
