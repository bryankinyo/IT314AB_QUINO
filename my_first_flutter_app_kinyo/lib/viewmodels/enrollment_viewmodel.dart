import 'package:flutter/foundation.dart';
import '../models/enrollment.dart';
import '../models/schedule.dart';
import '../repositories/enrollment_repository.dart';

// ViewModel para sa enrollments. Diri ang business rules sa enrollment
class EnrollmentViewModel extends ChangeNotifier {
  final EnrollmentRepository _repo = EnrollmentRepository();

  List<Enrollment> enrollments = [];
  bool isLoading = false;
  String? errorMessage;

  // i-clear ang karaan nga data una mag-open ug screen (walay notify)
  void reset() {
    enrollments = [];
    isLoading = true;
    errorMessage = null;
  }

  Future<void> loadEnrollments(int studentId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      enrollments = await _repo.getByStudent(studentId);
    } catch (e) {
      errorMessage = 'Failed to load enrollments: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  // ENROLLMENT WORKFLOW: mo-return ug error message, null kung success
  Future<String?> enroll(int studentId, Schedule schedule) async {
    try {
      // 1. dili pwede mag-enroll sa same subject kaduha
      if (await _repo.isDuplicate(studentId, schedule.subjectId)) {
        return 'Student is already enrolled in this subject.';
      }

      // 2. i-check kung naa pay slots
      final enrolled = await _repo.countEnrolled(schedule.id!);
      if (enrolled >= schedule.slotCapacity) {
        return 'No more slots available for this schedule.';
      }

      // 3. i-check kung naay conflict sa schedule
      if (await _repo.hasConflict(studentId, schedule)) {
        return 'Schedule conflict with another enrolled subject.';
      }

      // 4. pasar tanan, i-save na sa database
      await _repo.add(studentId, schedule.subjectId, schedule.id!);
      await loadEnrollments(studentId);
      return null;
    } catch (e) {
      return 'Enrollment failed: $e';
    }
  }

  // Change Schedule (same subject, lahi nga schedule)
  Future<String?> changeSchedule(Enrollment enrollment, Schedule newSchedule) async {
    try {
      if (newSchedule.id == enrollment.scheduleId) {
        return 'Student is already in this schedule.';
      }

      final enrolled = await _repo.countEnrolled(newSchedule.id!);
      if (enrolled >= newSchedule.slotCapacity) {
        return 'No more slots available for this schedule.';
      }

      // excludeId = dili isipon ang karon nga enrollment sa conflict check
      if (await _repo.hasConflict(
        enrollment.studentId,
        newSchedule,
        excludeId: enrollment.id!,
      )) {
        return 'Schedule conflict with another enrolled subject.';
      }

      await _repo.changeSchedule(enrollment.id!, newSchedule.id!);
      await loadEnrollments(enrollment.studentId);
      return null;
    } catch (e) {
      return 'Failed to change schedule: $e';
    }
  }

  // Drop Enrollment
  Future<String?> dropEnrollment(Enrollment enrollment) async {
    try {
      await _repo.delete(enrollment.id!);
      await loadEnrollments(enrollment.studentId);
      return null;
    } catch (e) {
      return 'Failed to drop subject: $e';
    }
  }
}

final enrollmentVM = EnrollmentViewModel();
