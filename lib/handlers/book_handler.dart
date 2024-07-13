import 'package:book_manager_backend/configs/configs.dart';
import 'package:book_manager_backend/models/models.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

class BookHandler {
  final Connection connection;

  BookHandler(this.connection);

  Future<Response> createBook(Request request) async {
    final req = bookModelFromJson(await request.readAsString());
    try {
      await connection.execute(
          Sql.named(
              "INSERT INTO books (book_name, book_author, book_content) VALUES (@book_name, @book_author, @book_content)"),
          parameters: {
            "book_name": req.bookName,
            "book_author": req.bookAuthor,
            "book_content": req.bookContent
          });

      return Response.ok(responseModelToJson(ResponseModel(
          success: true, message: "New book created", result: req.toJson())));
    } catch (e) {
      logger.e("createBook e: $e");
      return Response.internalServerError(
          body: responseModelToJson(ResponseModel(
              success: false, message: "Something went wrong.", result: null)));
    }
  }

  Future<Response> getAllBook(Request request) async {
    try {
      final result = await connection.execute(Sql("SELECT * FROM books"));
      if (result.isNotEmpty) {
        List<Map<String, dynamic>> books = [];

        for (int i = 0; i < result.length; i++) {
          books.add({
            "book_id": result[i][0],
            "book_name": result[i][1],
            "book_author": result[i][2],
            "book_content": result[i][3],
          });
        }

        return Response.ok(responseModelToJson(ResponseModel(
            success: true, message: "Books available", result: books)));
      } else {
        return Response.notFound(responseModelToJson(ResponseModel(
            success: false, message: "Books not available", result: null)));
      }
    } catch (e) {
      logger.e("getAllBook e: $e");
      return Response.internalServerError(
          body: responseModelToJson(ResponseModel(
              success: false, message: "Something went wrong.", result: null)));
    }
  }

  Future<Response> getSingleBook(Request request, String bookId) async {
    try {
      final result = await connection.execute(
          Sql.named("SELECT * FROM books WHERE book_id=@bookId"),
          parameters: {"bookId": bookId});
      if (result.isNotEmpty) {
        Map<String, dynamic> data = {
          "book_id": result.first[0],
          "book_name": result.first[1],
          "book_author": result.first[2],
          "book_content": result.first[3],
        };

        return Response.ok(responseModelToJson(ResponseModel(
            success: true, message: "This book available", result: data)));
      } else {
        return Response.notFound(responseModelToJson(ResponseModel(
            success: false, message: "This book not available", result: null)));
      }
    } catch (e) {
      logger.e("getSingleBook e: $e");
      return Response.internalServerError(
          body: responseModelToJson(ResponseModel(
              success: false, message: "Something went wrong.", result: null)));
    }
  }

  Future<Response> updateBook(Request request) async {
    final req = bookModelFromJson(await request.readAsString());
    try {
      if (req.bookId != null) {
        await connection.execute(
            Sql.named(
                "UPDATE books SET book_name=@book_name, book_author=@book_author, book_content=@book_content WHERE book_id=@book_id"),
            parameters: {
              "book_id": req.bookId,
              "book_name": req.bookName,
              "book_author": req.bookAuthor,
              "book_content": req.bookContent
            });

        return Response.ok(responseModelToJson(ResponseModel(
            success: true, message: "Book updated.", result: req.toJson())));
      } else {
        return Response.notFound(responseModelToJson(ResponseModel(
            success: false, message: "Book id not found.", result: null)));
      }
    } catch (e) {
      logger.e("updateBook e: $e");
      return Response.internalServerError(
          body: responseModelToJson(ResponseModel(
              success: false, message: "Something went wrong.", result: null)));
    }
  }

  Future<Response> deleteBook(Request request, String bookId) async {
    try {
      await connection.execute(
          Sql.named("DELETE FROM books WHERE book_id=@bookId"),
          parameters: {"bookId": bookId});

      return Response.ok(responseModelToJson(
          ResponseModel(success: true, message: "Book deleted", result: null)));
    } catch (e) {
      logger.e("deleteBook e:$e");
      return Response.internalServerError(
          body: responseModelToJson(ResponseModel(
              success: false, message: "Something went wrong.", result: null)));
    }
  }
}
