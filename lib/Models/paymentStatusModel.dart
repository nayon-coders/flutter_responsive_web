// To parse this JSON data, do
//
//     final paymentSatatusModel = paymentSatatusModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PaymentSatatusModel paymentSatatusModelFromJson(String str) => PaymentSatatusModel.fromJson(json.decode(str));

String paymentSatatusModelToJson(PaymentSatatusModel data) => json.encode(data.toJson());

class PaymentSatatusModel {
  final int code;
  final int timeLeft;
  final String state;
  final int loaded;
  final String wallet;
  final String txid;

  PaymentSatatusModel({
    required this.code,
    required this.timeLeft,
    required this.state,
    required this.loaded,
    required this.wallet,
    required this.txid,
  });

  factory PaymentSatatusModel.fromJson(Map<String, dynamic> json) => PaymentSatatusModel(
    code: json["code"],
    timeLeft: json["time_left"],
    state: json["state"],
    loaded: json["loaded"],
    wallet: json["wallet"],
    txid: json["txid"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "time_left": timeLeft,
    "state": state,
    "loaded": loaded,
    "wallet": wallet,
    "txid": txid,
  };
}
