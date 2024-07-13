import 'package:book_manager_backend/handlers/handlers.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_router/shelf_router.dart';

class BookRoute{
  final Connection connection;
  BookRoute(this.connection);

  BookHandler get _bookHandler => BookHandler(connection);

  Router get router => Router()
    ..get('/', _bookHandler.getAllBook)
    ..get('/<book_id>', _bookHandler.getSingleBook)
    ..put('/', _bookHandler.updateBook) //take book_id from body
    ..delete('/<book_id>', _bookHandler.deleteBook)
    ..post('/', _bookHandler.createBook);
}