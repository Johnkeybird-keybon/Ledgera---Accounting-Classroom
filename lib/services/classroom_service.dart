import 'package:cloud_firestore/cloud_firestore.dart';

class ClassroomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Get a single classroom document by its ID
  Stream<DocumentSnapshot> getClassroom(String classroomId) {
    return _firestore.collection('classrooms').doc(classroomId).snapshots();
  }

  // 2. Delete a classroom
  Future<void> deleteClassroom(String classroomId) async {
    await _firestore.collection('classrooms').doc(classroomId).delete();
  }

  // 3. Get all activities for a given classroom ID
  Stream<QuerySnapshot> getActivities(String classroomId) {
    return _firestore
        .collection('activities')
        .where('classroom_id', isEqualTo: classroomId)
        .snapshots();
  }

  // 4. Get all classrooms for a given student ID
  Stream<QuerySnapshot> getClassroomsForStudent(String studentId) {
    return _firestore
        .collection('classrooms')
        .where('students', arrayContains: studentId)
        .snapshots();
  }

  // 5. Get all classrooms for a teacher by teacher ID
  Stream<QuerySnapshot> getClassroomsForTeacher(String teacherId) {
    return _firestore
        .collection('classrooms')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots();
  }

  // 6. Search for a classroom by its classroom code
  // Note: The field name is 'code' as saved in createClassroom.
  Stream<DocumentSnapshot?> getClassroomByCode(String code) {
    return _firestore
        .collection('classrooms')
        .where('code', isEqualTo: code)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    });
  }

  // 7. Add a student to a classroom
  Future<void> addStudentToClassroom(
      String classroomId, String studentId) async {
    await _firestore.collection('classrooms').doc(classroomId).update({
      'students': FieldValue.arrayUnion([studentId])
    });
  }

  // 8. Create a new classroom
  Future<DocumentReference> createClassroom(
    String className,
    String teacherId,
    List<String> students,
    String room,
    String subject,
    List<String> templates,
    String section,
  ) async {
    final classroomData = {
      'className': className,
      'teacherId': teacherId,
      'students': students,
      'room': room,
      'subject': subject,
      'templates': templates,
      'section': section,
      'createdAt': FieldValue.serverTimestamp(),
      'code': _generateRandomCode(6), // Saved under the field 'code'
    };

    DocumentReference ref =
        await _firestore.collection('classrooms').add(classroomData);
    return ref;
  }

  // 9. Get user data (assuming a 'users' collection exists)
  Future<DocumentSnapshot> getUser(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Helper: Generate a random classroom code
  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) {
      return chars[
          (DateTime.now().microsecondsSinceEpoch + index) % chars.length];
    }).join();
  }

  // 10. Create a new activity (Cash Flow Statement) with detailed structure
  Future<void> createActivity({
    required String activityId,
    required String classroomId,
    required String teacherId,
    required String title,
    required String description,
    // Cash Flow Statement fields:
    required String company,
    required String period,
    required int receiptsFromCustomers,
    required int paymentsToSuppliersAndEmployees,
    required int netCashOperating,
    required int purchasesPropertyEquipment,
    required int netCashInvesting,
    required int longTermLoan,
    required int additionalInvestment,
    required int withdrawalsByOwner,
    required int netCashFinancing,
    required int netIncreaseCash,
    required int cashBeginning,
    required int cashEnding,
    required int totalCells, // e.g., 12
  }) async {
    final Map<String, dynamic> activityData = {
      "activity_id": activityId,
      "classroom_id": classroomId,
      "teacher_id": teacherId,
      "title": title,
      "description": description,
      "statement": {
        "company": company,
        "period": period,
        "operating_activities": {
          "receipts_from_customers": receiptsFromCustomers,
          "payments_to_suppliers_and_employees":
              paymentsToSuppliersAndEmployees,
          "net_cash_operating": netCashOperating,
        },
        "investing_activities": {
          "purchases_property_equipment": purchasesPropertyEquipment,
          "net_cash_investing": netCashInvesting,
        },
        "financing_activities": {
          "long_term_loan": longTermLoan,
          "additional_investment": additionalInvestment,
          "withdrawals_by_owner": withdrawalsByOwner,
          "net_cash_financing": netCashFinancing,
        },
        "net_increase_cash": netIncreaseCash,
        "cash_beginning": cashBeginning,
        "cash_ending": cashEnding,
      },
      "total_cells": totalCells,
      "created_at": Timestamp.now(),
    };

    await _firestore.collection('activities').doc(activityId).set(activityData);
  }

  // 11. Submit a student's answer for an activity
  Future<void> submitAnswer({
    required String submissionId,
    required String activityId,
    required String studentId,
    required Map<String, dynamic> answerStatement,
    required int correctCells,
  }) async {
    final Map<String, dynamic> submissionData = {
      "submission_id": submissionId,
      "activity_id": activityId,
      "student_id": studentId,
      "answers": {
        "statement": answerStatement,
      },
      "correct_cells": correctCells,
      "score": correctCells,
      "chatgpt_evaluation": {},
      "teacher_reviewed": false,
      "updated_score": null,
      "submitted_at": Timestamp.now(),
    };

    await _firestore
        .collection('submissions')
        .doc(submissionId)
        .set(submissionData);
  }
}
