import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/subject.dart';

// Repository: SQL queries para sa subjects
class SubjectRepository {
  Connection get db => DbConnection.connection;

  Future<List<Subject>> getAll() async {
    final result = await db.execute(
      Sql.named('SELECT * FROM subjects ORDER BY subject_name'),
    );
    return result.map((row) => Subject.fromMap(row.toColumnMap())).toList();
  }

  Future<void> add(Subject subject) async {
    await db.execute(
      Sql.named(
        'INSERT INTO subjects (subject_code, subject_name, units, description) '
        'VALUES (@subject_code, @subject_name, @units, @description)',
      ),
      parameters: subject.toMap(),
    );
  }

  Future<void> update(Subject subject) async {
    await db.execute(
      Sql.named(
        'UPDATE subjects SET subject_code = @subject_code, subject_name = @subject_name, '
        'units = @units, description = @description WHERE subject_id = @id',
      ),
      parameters: {...subject.toMap(), 'id': subject.id},
    );
  }

  // i-delete una ang grades, enrollments, ug schedules sa subject, human ang subject
  // runTx = all or nothing: kung naay mag-fail, walay ma-delete
  Future<void> delete(int id) async {
    await db.runTx((tx) async {
      await tx.execute(
        Sql.named(
          'DELETE FROM grades WHERE enrollment_id IN '
          '(SELECT enrollment_id FROM enrollments WHERE subject_id = @id)',
        ),
        parameters: {'id': id},
      );
      await tx.execute(
        Sql.named('DELETE FROM enrollments WHERE subject_id = @id'),
        parameters: {'id': id},
      );
      await tx.execute(
        Sql.named('DELETE FROM schedules WHERE subject_id = @id'),
        parameters: {'id': id},
      );
      await tx.execute(
        Sql.named('DELETE FROM subjects WHERE subject_id = @id'),
        parameters: {'id': id},
      );
    });
  }

  // subject_code kay UNIQUE sa database, mao nga i-check una kung gigamit na
  Future<bool> codeExists(String code, {int excludeId = -1}) async {
    final result = await db.execute(
      Sql.named(
        'SELECT COUNT(*) FROM subjects '
        'WHERE LOWER(subject_code) = LOWER(@code) AND subject_id <> @id',
      ),
      parameters: {'code': code, 'id': excludeId},
    );
    return (result.first[0] as int) > 0;
  }
}
