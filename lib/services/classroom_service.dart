import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ClassroomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateClassroomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }

  Future<DocumentReference> createClassroom(
      String className,
      String teacherId,
      List<String> students,
      String room,
      String subject,
      List<String> templates,
      String section) async {
    String code = _generateClassroomCode(6); // Generate a 6-character code
    DocumentReference classroomRef =
        await _firestore.collection('classrooms').add({
      'className': className,
      'teacherId': teacherId,
      'students': students,
      'room': room,
      'subject': subject,
      'templates': templates,
      'section': section,
      'code': code, // Save the generated code
    });
    return classroomRef;
  }

  Stream<DocumentSnapshot> getClassroomByCode(String code) {
    return _firestore
        .collection('classrooms')
        .where('code', isEqualTo: code)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  Future<void> addStudentToClassroom(
      String classroomId, String studentId) async {
    await _firestore.collection('classrooms').doc(classroomId).update({
      'students': FieldValue.arrayUnion([studentId]),
    });
  }

  Stream<QuerySnapshot> getClassroomsForTeacher(String teacherId) {
    return _firestore
        .collection('classrooms')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots();
  }

  Stream<QuerySnapshot> getClassroomsForStudent(String studentId) {
    return _firestore
        .collection('classrooms')
        .where('students', arrayContains: studentId)
        .snapshots();
  }

  Stream<DocumentSnapshot> getClassroom(String classroomId) {
    return _firestore.collection('classrooms').doc(classroomId).snapshots();
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }

  Stream<QuerySnapshot> getActivities(String classroomId) {
    return _firestore
        .collection('classrooms')
        .doc(classroomId)
        .collection('activities')
        .snapshots();
  }

  Future<void> createActivity(String classroomId, String activityName,
      String correctAnswer, int points) async {
    await _firestore
        .collection('classrooms')
        .doc(classroomId)
        .collection('activities')
        .add({
      'name': activityName,
      'correctAnswer': correctAnswer,
      'points': points,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<DocumentSnapshot> getActivity(String classroomId, String activityId) {
    return _firestore
        .collection('classrooms')
        .doc(classroomId)
        .collection('activities')
        .doc(activityId)
        .snapshots();
  }

  Future<void> submitAnswer(String classroomId, String activityId,
      String studentId, String answer) async {
    await _firestore
        .collection('classrooms')
        .doc(classroomId)
        .collection('activities')
        .doc(activityId)
        .collection('answers')
        .doc(studentId)
        .set({
      'answer': answer,
      'submittedAt': Timestamp.now(),
    });
  }

  Future<void> deleteClassroom(String classroomId) async {
    await _firestore.collection('classrooms').doc(classroomId).delete();
  }
}
