import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rakibproject1/utility/appConfig.dart';

import '../Models/balanceModel.dart';
import '../Models/cardBuySuccessModel.dart';
import '../Models/paymentStatusModel.dart';

class ApiController{
  
  //balance
  static Future<BalanceModel> getBalance()async{
    var res = await http.get(Uri.parse(AppConfig.BALANCE),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
        "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
      },
    );
    return BalanceModel.fromJson(jsonDecode(res.body));
  }

  //PAYMENT_STATUS_CHECK
  static Future<PaymentSatatusModel> paymentStatusCheck()async{
    var res = await http.get(Uri.parse(AppConfig.PAYMENT_STATUS_CHECK),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
        "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
      },
    );
    print("data ===== ${res.body}");
    return PaymentSatatusModel.fromJson(jsonDecode(res.body));
  }



}