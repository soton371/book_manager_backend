import 'dart:convert';
import 'package:book_manager_backend/configs/constant.dart';
import 'package:book_manager_backend/models/models.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

class AuthHandler {
  final Connection connection;

  AuthHandler(this.connection);

  //for login
  Future<Response> login(Request request) async {
    try {
      final req = userModelFromJson(await request.readAsString());

      final checkUser = await connection.execute(
          Sql.named(
              "SELECT * FROM users WHERE email=@email AND password=@password"),
          parameters: {"email": req.email, "password": _hashPassword(req.password)});

      if (checkUser.isNotEmpty) {

        Map<String, String> result = {
          "full_name": checkUser.first[1].toString(),
          "email": checkUser.first[2].toString()
        };

        final token = _generateToken(result);

        result['token'] = token;

        return Response.ok(responseModelToJson(ResponseModel(
            success: true,
            message: "Login success.",
            result: result)));
      } else {
        return Response.notFound(responseModelToJson(ResponseModel(
            success: false,
            message: "Your email or password is wrong.",
            result: null)));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //for register
  Future<Response> register(Request request) async {
    try {
      final req = userModelFromJson(await request.readAsString());
      final checkUsers = await connection.execute(
          Sql.named("SELECT * FROM users WHERE email=@email"),
          parameters: {"email": req.email});

      if (checkUsers.isEmpty) {
        await connection.execute(
            Sql.named(
                "INSERT INTO users (full_name, email, password) VALUES (@full_name, @email, @password)"),
            parameters: {
              "full_name": req.fullName,
              "email": req.email,
              "password": _hashPassword(req.password)
            });

        final responseData = ResponseModel(
            success: true, message: "User created.", result: req.toJson());
        return Response.ok(responseModelToJson(responseData));
      } else {
        final responseData = ResponseModel(
            success: false, message: "User already exist.", result: null);
        return Response.ok(responseModelToJson(responseData));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _generateToken(Map payload){
    final jwt = JWT(payload);
    return jwt.sign(SecretKey(secreteKey));
  }
}
