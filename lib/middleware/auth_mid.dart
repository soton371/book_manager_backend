import 'package:book_manager_backend/configs/configs.dart';
import 'package:book_manager_backend/models/models.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

class AuthMiddleware {
  static Middleware checkAuthentication() => (innerHandler) {
        return (request) {
          if (request.url != Uri.parse("auth/login") &&
              request.url != Uri.parse("auth/registration")) {
            final token = _extractToken(request);
            if (token != null) {
              final verify = JWT.tryVerify(token, SecretKey(secreteKey));
              if (verify != null) {
                return innerHandler(request);
              }
            }
            return Response.unauthorized(responseModelToJson(ResponseModel(
                success: false,
                message: "Unauthorized request.",
                result: null)));
          } else {
            return innerHandler(request);
          }
        };
      };

  static String? _extractToken(Request request) {
    final authorization = request.headers['Authorization'];
    if (authorization != null && authorization.startsWith("Bearer ")) {
      return authorization.substring(7);
    } else {
      return null;
    }
  }
}
