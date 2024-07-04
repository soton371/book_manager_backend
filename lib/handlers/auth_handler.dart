import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

class AuthHandler{

  final Connection connection;
  AuthHandler(this.connection);

  //for login
  Response login(Request req){
    return Response.ok(jsonEncode({"message": "Server is ok"}));
  }

  //for register
  Response register(Request req){
    return Response.ok(jsonEncode({"message": "Server is ok"}));
  }
}