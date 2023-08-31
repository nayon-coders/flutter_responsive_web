// To parse this JSON data, do
//
//     final cardByeSuccessModel = cardByeSuccessModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CardByeSuccessModel cardByeSuccessModelFromJson(String str) => CardByeSuccessModel.fromJson(json.decode(str));

String cardByeSuccessModelToJson(CardByeSuccessModel data) => json.encode(data.toJson());

class CardByeSuccessModel {
  final int code;
  final String msg;
  final List<int> cardIds;
  final int price;

  CardByeSuccessModel({
    required this.code,
    required this.msg,
    required this.cardIds,
    required this.price,
  });

  factory CardByeSuccessModel.fromJson(Map<String, dynamic> json) => CardByeSuccessModel(
    code: json["code"],
    msg: json["msg"],
    cardIds: List<int>.from(json["card_ids"].map((x) => x)),
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "msg": msg,
    "card_ids": List<dynamic>.from(cardIds.map((x) => x)),
    "price": price,
  };
}
