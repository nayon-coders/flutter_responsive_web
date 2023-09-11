// To parse this JSON data, do
//
//     final adminModel = adminModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AdminModel adminModelFromJson(String str) => AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  final String status;
  final int statusCode;
  final Api api;
  final String message;
  final Data data;

  AdminModel({
    required this.status,
    required this.statusCode,
    required this.api,
    required this.message,
    required this.data,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    status: json["status"],
    statusCode: json["status_code"],
    api: Api.fromJson(json["api"]),
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "api": api.toJson(),
    "message": message,
    "data": data.toJson(),
  };
}

class Api {
  final String endpoint;
  final String method;

  Api({
    required this.endpoint,
    required this.method,
  });

  factory Api.fromJson(Map<String, dynamic> json) => Api(
    endpoint: json["endpoint"],
    method: json["method"],
  );

  Map<String, dynamic> toJson() => {
    "endpoint": endpoint,
    "method": method,
  };
}

class Data {
  final int id;
  final String username;
  final String token;
  final dynamic createdAt;
  final DateTime updatedAt;

  Data({
    required this.id,
    required this.username,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    token: json["token"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "token": token,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
  };
}
