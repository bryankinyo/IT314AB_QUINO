import 'package:postgres/postgres.dart';
import 'db_config.dart';

// Shared connection for all repositories
class DbConnection {
  static Connection? _connection;

  // Get the existing database connection
  static Connection get connection {
    if (_connection == null) {
      throw Exception('Database is not connected yet');
    }

    return _connection!;
  }

  // Connect to NeonDB using SSL
  static Future<void> connect() async {
    if (_connection != null && _connection!.isOpen) {
      return;
    }

    _connection = await Connection.open(
      Endpoint(
        host: DbConfig.host,
        port: DbConfig.port,
        database: DbConfig.database,
        username: DbConfig.username,
        password: DbConfig.password,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );

    // Test database connection
    await _connection!.execute('SELECT 1');
  }

  // Close database connection
  static Future<void> disconnect() async {
    if (_connection != null && _connection!.isOpen) {
      await _connection!.close();
      _connection = null;
    }
  }
}
