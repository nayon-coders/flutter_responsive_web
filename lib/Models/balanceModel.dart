// To parse this JSON data, do
//
//     final balanceModel = balanceModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BalanceModel balanceModelFromJson(String str) => BalanceModel.fromJson(json.decode(str));

String balanceModelToJson(BalanceModel data) => json.encode(data.toJson());

class BalanceModel {
  final double balanceInBtc;
  final double balanceInUsd;
  final double bitcoinPrice;

  BalanceModel({
    required this.balanceInBtc,
    required this.balanceInUsd,
    required this.bitcoinPrice,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
    balanceInBtc: json["balance_in_btc"]?.toDouble(),
    balanceInUsd: json["balance_in_usd"]?.toDouble(),
    bitcoinPrice: json["bitcoin_price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "balance_in_btc": balanceInBtc,
    "balance_in_usd": balanceInUsd,
    "bitcoin_price": bitcoinPrice,
  };
}
