import 'package:postgres/postgres.dart';

class DBConfig {
  static Future<Connection> get connection async => await Connection.open(
      Endpoint(
          host: 'localhost',
          database: 'book_manager',
          username: 'postgres',
          password: '1234'),
      settings: ConnectionSettings(
        sslMode: SslMode.disable
      ));
}