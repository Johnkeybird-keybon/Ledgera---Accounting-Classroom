import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ledgeroom/screens/worksheet_template.dart'; // Ensure this import is present
import '../services/classroom_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for current user ID check

class ClassroomDetails extends StatefulWidget {
  final String classroomId;
  final String classroomName;

  const ClassroomDetails(
      {required this.classroomId, required this.classroomName, super.key});

  @override
  ClassroomDetailsState createState() => ClassroomDetailsState();
}

class ClassroomDetailsState extends State<ClassroomDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ClassroomService classroomService = ClassroomService();
  String? classroomCode;
  String? teacherId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchClassroomDetails();
  }

  Future<void> _fetchClassroomDetails() async {
    var classroomSnapshot =
        await classroomService.getClassroom(widget.classroomId).first;
    if (classroomSnapshot.exists) {
      var classroomData = classroomSnapshot.data() as Map<String, dynamic>;
      setState(() {
        classroomCode = classroomData['code'];
        teacherId = classroomData['teacherId'];
      });
    }
  }

  Future<void> _deleteClassroom() async {
    await classroomService.deleteClassroom(widget.classroomId);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Classroom deleted successfully')),
      );
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classroomName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Classwork"),
            Tab(text: "People"),
          ],
        ),
        actions: [
          if (currentUserId == teacherId)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Classroom'),
                      content: const Text(
                          'Are you sure you want to delete this classroom?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteClassroom();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClassworkTab(),
          _buildPeopleTab(),
        ],
      ),
      floatingActionButton: classroomCode != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: classroomCode!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Classroom code copied to clipboard')),
                );
              },
              label: const Text('Copy Code'),
              icon: const Icon(Icons.copy),
            )
          : null,
    );
  }

  Widget _buildClassworkTab() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: classroomService.getActivities(widget.classroomId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var activities = snapshot.data!.docs;
              debugPrint(
                  'Activities loaded: ${activities.length}'); // Debugging print

              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  var activity = activities[index];
                  debugPrint(
                      'Activity name: ${activity['name']}'); // Log the activity name

                  return ListTile(
                    title: Text(activity['name']),
                    subtitle:
                        Text("Created At: ${activity['createdAt'].toDate()}"),
                    onTap: () {
                      debugPrint(
                          'Activity tapped: ${activity['name']}'); // Log tap event
                      if (activity['name'].contains('Worksheet')) {
                        debugPrint(
                            'Navigating to WorksheetTemplate'); // Confirm navigation
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorksheetTemplate(
                                  classroomId: widget.classroomId),
                            ),
                          ).then((value) => debugPrint('Navigation complete.'));
                        } catch (e) {
                          debugPrint(
                              'Navigation error: $e'); // Log navigation error
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Activity not supported yet.')),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return _buildAddActivityOptions();
                },
              );
            },
            child: const Text('Add Classwork'),
          ),
        ),
      ],
    );
  }

  Widget _buildPeopleTab() {
    return StreamBuilder<DocumentSnapshot>(
      stream: classroomService.getClassroom(widget.classroomId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var classroom = snapshot.data;
        var classroomData = classroom?.data()
            as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
        var students = classroomData?.containsKey('students') ?? false
            ? List<String>.from(classroomData!['students'])
            : [];

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            var studentId = students[index];
            return FutureBuilder<DocumentSnapshot>(
              future: classroomService.getUser(studentId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const ListTile(title: Text('Loading...'));
                }

                var student = snapshot.data!;
                return ListTile(
                  title: Text(student['name']),
                  subtitle: Text(student['email']),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAddActivityOptions() {
    return ListView(
      children: [
        ListTile(
          title: const Text('Worksheet'),
          onTap: () {
            debugPrint('Add Classwork tapped'); // Debugging print
            Navigator.pop(context);
            try {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WorksheetTemplate(classroomId: widget.classroomId),
                ),
              ).then((value) => debugPrint('Navigation complete.'));
            } catch (e) {
              debugPrint('Navigation error: $e'); // Log navigation error
            }
          },
        ),
        // Add more activities here if needed
      ],
    );
  }
}
