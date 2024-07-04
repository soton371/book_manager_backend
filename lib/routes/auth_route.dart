
import 'package:book_manager_backend/handlers/handlers.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRoute{

  final Connection connection;
  AuthRoute(this.connection);

  AuthHandler get _handler => AuthHandler(connection);

  Router get router => Router()
    ..post('/auth/login', _handler.login)
    ..get('/auth/registration', _handler.register);
}



/*

Response rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}
*/
