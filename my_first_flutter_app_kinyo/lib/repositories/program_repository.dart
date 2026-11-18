import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/program.dart';

// Repository: SQL query para sa programs (read ra)
class ProgramRepository {
  Connection get db => DbConnection.connection;

  Future<List<Program>> getAll() async {
    final result = await db.execute(
      Sql.named('SELECT * FROM program ORDER BY program_name'),
    );
    return result.map((row) => Program.fromMap(row.toColumnMap())).toList();
  }
}
