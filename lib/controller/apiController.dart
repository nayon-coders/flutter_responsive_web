import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rakibproject1/controller/sharedPrefarance.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/adminModel.dart';
import '../Models/balanceModel.dart';
import '../Models/cardBuySuccessModel.dart';
import '../Models/paymentStatusModel.dart';

class ApiController{

  //balance
  static Future<AdminModel> getAdminData()async{
    var res = await http.get(Uri.parse(AppConfig.ADMIN_DATA),
    );
    print("admin data === ${res.body}");
    SaveData.adminData(jsonDecode(res.body));
    return AdminModel.fromJson(jsonDecode(res.body));
  }
  
  //balance
  static Future gerSingleUser()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString("token");
    var userId = _prefs.getString("userId");
    var res = await http.get(Uri.parse("${AppConfig.USER_PROFILE}"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    return jsonDecode(res.body);
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