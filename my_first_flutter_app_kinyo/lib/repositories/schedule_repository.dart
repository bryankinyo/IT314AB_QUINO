import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/schedule.dart';

// Repository: SQL queries para sa schedules
class ScheduleRepository {
  Connection get db => DbConnection.connection;

  // base query: naa na ang subject info ug ang gidaghanon sa naka-enroll na
  // to_char = i-convert ang TIME ngadto sa text nga 'HH:MM' para dali gamiton sa Dart
  final String baseQuery = '''
    SELECT sc.schedule_id, sc.subject_id, sc.day_of_week, sc.room, sc.slot_capacity,
      to_char(sc.start_time, 'HH24:MI') AS start_time,
      to_char(sc.end_time, 'HH24:MI') AS end_time,
      su.subject_code, su.subject_name,
      (SELECT COUNT(*) FROM enrollments e WHERE e.schedule_id = sc.schedule_id) AS enrolled_count
    FROM schedules sc
    JOIN subjects su ON su.subject_id = sc.subject_id''';

  // tanang schedules (gamiton sa enroll screen)
  Future<List<Schedule>> getAll() async {
    final result = await db.execute(
      Sql.named('$baseQuery ORDER BY su.subject_name, sc.day_of_week, sc.start_time'),
    );
    return result.map((row) => Schedule.fromMap(row.toColumnMap())).toList();
  }

  // schedules sa usa ka subject ra
  Future<List<Schedule>> getBySubject(int subjectId) async {
    final result = await db.execute(
      Sql.named(
        '$baseQuery WHERE sc.subject_id = @subject_id '
        'ORDER BY sc.day_of_week, sc.start_time',
      ),
      parameters: {'subject_id': subjectId},
    );
    return result.map((row) => Schedule.fromMap(row.toColumnMap())).toList();
  }

  // CAST(CAST(@x AS TEXT) AS TIME) = i-pasa ang 'HH:MM' text ug i-convert ngadto sa TIME column
  Future<void> add(Schedule schedule) async {
    await db.execute(
      Sql.named('''
        INSERT INTO schedules (subject_id, day_of_week, start_time, end_time, room, slot_capacity)
        VALUES (@subject_id, @day_of_week,
                CAST(CAST(@start_time AS TEXT) AS TIME),
                CAST(CAST(@end_time AS TEXT) AS TIME),
                @room, @slot_capacity)'''),
      parameters: schedule.toMap(),
    );
  }

  Future<void> update(Schedule schedule) async {
    await db.execute(
      Sql.named('''
        UPDATE schedules SET day_of_week = @day_of_week,
          start_time = CAST(CAST(@start_time AS TEXT) AS TIME),
          end_time = CAST(CAST(@end_time AS TEXT) AS TIME),
          room = @room, slot_capacity = @slot_capacity
        WHERE schedule_id = @id'''),
      parameters: {
        'day_of_week': schedule.day,
        'start_time': schedule.startTime,
        'end_time': schedule.endTime,
        'room': schedule.room,
        'slot_capacity': schedule.slotCapacity,
        'id': schedule.id,
      },
    );
  }

  // i-delete una ang grades ug enrollments sa schedule, human ang schedule
  // runTx = all or nothing: kung naay mag-fail, walay ma-delete
  Future<void> delete(int id) async {
    await db.runTx((tx) async {
      await tx.execute(
        Sql.named(
          'DELETE FROM grades WHERE enrollment_id IN '
          '(SELECT enrollment_id FROM enrollments WHERE schedule_id = @id)',
        ),
        parameters: {'id': id},
      );
      await tx.execute(
        Sql.named('DELETE FROM enrollments WHERE schedule_id = @id'),
        parameters: {'id': id},
      );
      await tx.execute(
        Sql.named('DELETE FROM schedules WHERE schedule_id = @id'),
        parameters: {'id': id},
      );
    });
  }
}
