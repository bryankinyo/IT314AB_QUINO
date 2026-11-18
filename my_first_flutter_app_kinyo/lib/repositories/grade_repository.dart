import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';

// Repository: SQL queries para sa grades
class GradeRepository {
  Connection get db => DbConnection.connection;

  // Validate grade value
  void validateGrade(double gradeValue) {
    if (gradeValue < 1.00 || gradeValue > 5.00) {
      throw ArgumentError(
        'Invalid grade. Grade must be between 1.00 and 5.00.',
      );
    }

    // Maximum of 2 decimal places
    if ((gradeValue * 100 - (gradeValue * 100).round()).abs() > 0.000001) {
      throw ArgumentError('Invalid grade. Only 2 decimal places are allowed.');
    }
  }

  // Check if grade is passing
  bool isPassingGrade(double gradeValue) {
    validateGrade(gradeValue);
    return gradeValue <= 3.00;
  }

  // Check if enrollment exists before adding a grade
  Future<bool> enrollmentExists(int enrollmentId) async {
    final result = await db.execute(
      Sql.named('SELECT COUNT(*) FROM enrollments WHERE enrollment_id = @id'),
      parameters: {'id': enrollmentId},
    );

    return (result.first[0] as num) > 0;
  }

  // Add grade
  Future<void> add(int enrollmentId, double gradeValue, String? remarks) async {
    validateGrade(gradeValue);

    if (!await enrollmentExists(enrollmentId)) {
      throw ArgumentError('Enrollment does not exist.');
    }

    await db.execute(
      Sql.named(
        'INSERT INTO grades '
        '(enrollment_id, grade_value, remarks, date_recorded) '
        'VALUES (@enrollment_id, CAST(@grade_value AS NUMERIC(3,2)), '
        '@remarks, CURRENT_DATE)',
      ),
      parameters: {
        'enrollment_id': enrollmentId,
        'grade_value': gradeValue,
        'remarks': remarks,
      },
    );
  }

  // Update grade
  Future<void> update(int gradeId, double gradeValue, String? remarks) async {
    validateGrade(gradeValue);

    await db.execute(
      Sql.named(
        'UPDATE grades SET '
        'grade_value = CAST(@grade_value AS NUMERIC(3,2)), '
        'remarks = @remarks, '
        'date_recorded = CURRENT_DATE '
        'WHERE grade_id = @id',
      ),
      parameters: {
        'grade_value': gradeValue,
        'remarks': remarks,
        'id': gradeId,
      },
    );
  }

  // Delete grade
  Future<void> delete(int gradeId) async {
    await db.execute(
      Sql.named('DELETE FROM grades WHERE grade_id = @id'),
      parameters: {'id': gradeId},
    );
  }
}
