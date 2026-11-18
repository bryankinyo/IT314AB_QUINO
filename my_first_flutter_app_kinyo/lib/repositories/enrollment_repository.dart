import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/enrollment.dart';
import '../models/schedule.dart';

// Repository: SQL queries para sa enrollments
class EnrollmentRepository {
  Connection get db => DbConnection.connection;

  // tanang enrolled subjects sa usa ka student (naay grade kung naa)
  Future<List<Enrollment>> getByStudent(int studentId) async {
    final result = await db.execute(
      Sql.named('''
        SELECT e.enrollment_id, e.student_id, e.subject_id, e.schedule_id, e.status,
               su.subject_code, su.subject_name,
               sc.day_of_week, sc.room,
               to_char(sc.start_time, 'HH24:MI') AS start_time,
               to_char(sc.end_time, 'HH24:MI') AS end_time,
               g.grade_id, CAST(g.grade_value AS DOUBLE PRECISION) AS grade_value, g.remarks
        FROM enrollments e
        JOIN schedules sc ON sc.schedule_id = e.schedule_id
        JOIN subjects su ON su.subject_id = e.subject_id
        LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
        WHERE e.student_id = @student_id
        ORDER BY su.subject_name'''),
      parameters: {'student_id': studentId},
    );
    return result.map((row) => Enrollment.fromMap(row.toColumnMap())).toList();
  }

  Future<void> add(int studentId, int subjectId, int scheduleId) async {
    await db.execute(
      Sql.named(
        'INSERT INTO enrollments (student_id, subject_id, schedule_id, enrolled_at, status) '
        "VALUES (@student_id, @subject_id, @schedule_id, NOW(), 'Enrolled')",
      ),
      parameters: {
        'student_id': studentId,
        'subject_id': subjectId,
        'schedule_id': scheduleId,
      },
    );
  }

  // Change Schedule: ilisan ang schedule sa enrollment
  Future<void> changeSchedule(int enrollmentId, int newScheduleId) async {
    await db.execute(
      Sql.named(
        'UPDATE enrollments SET schedule_id = @schedule_id WHERE enrollment_id = @id',
      ),
      parameters: {'schedule_id': newScheduleId, 'id': enrollmentId},
    );
  }

  // Drop Enrollment: i-delete una ang grade (kung naa), human ang enrollment
  Future<void> delete(int enrollmentId) async {
    await db.runTx((tx) async {
      await tx.execute(
        Sql.named('DELETE FROM grades WHERE enrollment_id = @id'),
        parameters: {'id': enrollmentId},
      );
      await tx.execute(
        Sql.named('DELETE FROM enrollments WHERE enrollment_id = @id'),
        parameters: {'id': enrollmentId},
      );
    });
  }

  // RULE 1: naka-enroll na ba ang student sa same nga subject?
  Future<bool> isDuplicate(int studentId, int subjectId) async {
    final result = await db.execute(
      Sql.named(
        'SELECT COUNT(*) FROM enrollments '
        'WHERE student_id = @student_id AND subject_id = @subject_id',
      ),
      parameters: {'student_id': studentId, 'subject_id': subjectId},
    );
    return (result.first[0] as int) > 0;
  }

  // pila na ang naka-enroll sa usa ka schedule
  Future<int> countEnrolled(int scheduleId) async {
    final result = await db.execute(
      Sql.named('SELECT COUNT(*) FROM enrollments WHERE schedule_id = @schedule_id'),
      parameters: {'schedule_id': scheduleId},
    );
    return result.first[0] as int;
  }

  // RULE 2: naay conflict ba sa schedule? (same day ug nag-overlap ang oras)
  // excludeId = para sa Change Schedule, dili isipon ang karon nga enrollment
  Future<bool> hasConflict(
    int studentId,
    Schedule schedule, {
    int excludeId = -1,
  }) async {
    final result = await db.execute(
      Sql.named('''
        SELECT COUNT(*) FROM enrollments e
        JOIN schedules sc ON sc.schedule_id = e.schedule_id
        WHERE e.student_id = @student_id
          AND sc.day_of_week = @day
          AND sc.start_time < CAST(CAST(@end_time AS TEXT) AS TIME)
          AND sc.end_time > CAST(CAST(@start_time AS TEXT) AS TIME)
          AND e.enrollment_id <> @exclude_id'''),
      parameters: {
        'student_id': studentId,
        'day': schedule.day,
        'start_time': schedule.startTime,
        'end_time': schedule.endTime,
        'exclude_id': excludeId,
      },
    );
    return (result.first[0] as int) > 0;
  }
}
