import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveData{
  static Future storeAuthData(res)async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("token", res["data"]["bearer_token"].toString());
    _pref.setString("userId", res["data"]["user"]["id"].toString());
    _pref.setString("userName", res["data"]["user"]["user_name"].toString());
  }

  static Future adminData(res)async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("refund_length", res["data"]["refund_length"].toString());
    _pref.setString("card_amount", res["data"]["card_amount"].toString());
  }
}