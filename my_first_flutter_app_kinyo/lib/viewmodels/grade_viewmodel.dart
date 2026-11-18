import 'package:flutter/foundation.dart';
import '../repositories/grade_repository.dart';

// ViewModel para sa grades
class GradeViewModel extends ChangeNotifier {
  final GradeRepository _repo = GradeRepository();

  Future<String?> addGrade(int enrollmentId, double gradeValue, String? remarks) async {
    try {
      // RULE: kinahanglan naay enrollment una
      if (!await _repo.enrollmentExists(enrollmentId)) {
        return 'Enrollment not found. Enroll the student first.';
      }
      await _repo.add(enrollmentId, gradeValue, remarks);
      return null;
    } catch (e) {
      return 'Failed to add grade: $e';
    }
  }

  Future<String?> updateGrade(int gradeId, double gradeValue, String? remarks) async {
    try {
      await _repo.update(gradeId, gradeValue, remarks);
      return null;
    } catch (e) {
      return 'Failed to update grade: $e';
    }
  }

  Future<String?> deleteGrade(int gradeId) async {
    try {
      await _repo.delete(gradeId);
      return null;
    } catch (e) {
      return 'Failed to delete grade: $e';
    }
  }
}

final gradeVM = GradeViewModel();
