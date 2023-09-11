import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rakibproject1/controller/sharedPrefarance.dart';
import 'package:rakibproject1/responsive/responsive.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/utility/colors.dart';
import 'package:rakibproject1/view/auth/doPayment.dart';
import 'package:rakibproject1/view/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../home/dashboard.dart';

class RegistrationFee extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  const RegistrationFee({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<RegistrationFee> createState() => _RegistrationFeeState();
}

class _RegistrationFeeState extends State<RegistrationFee> {

  final user = TextEditingController();
  final jabber = TextEditingController();
  final pass = TextEditingController();
  final Cpass = TextEditingController();
  final invitedCode = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Center(
            child: Container(
              width: Responsive.isMobile(context) ? size.width*.90 : size.width*.40,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(0,2),
                        spreadRadius: 5,
                        blurRadius: 5
                    )
                  ]
              ),
              child: Column(

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Text("[Registration Fee: \$50]",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Pay \$50 as a registration fee throw by Bitcoin. Without pay you can not make and account."),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: ()=>makePayment(),
                    child: Container(
                      width: Responsive.isMobile(context)? size.width*.60 : size.width*.40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: isLoading ? CircularProgressIndicator(strokeWidth: 1, color: Colors.white,)
                              :  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.attach_money, color: Colors.white,),
                              SizedBox(width: 5,),
                              Text("Pay \$50",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool showError = false;



  Future<void> makePayment() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userName = _prefs.getString("userName");
    var userId = _prefs.getString("userId");
    var token = _prefs.getString("token");
    setState(() =>isLoading = true);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CC-Version': '2018-03-22',
      'X-CC-Api-Key': '41ec03d8-e159-4743-a3a4-331d98bcb93b'
    };
    var request =await http.post(Uri.parse(AppConfig.COINBASE),
      body: json.encode({
        "name": "Rakib",
        "description": "Pay \$50 as a registration fee throw by Bitcoin. Without pay you can not make and account.",
        "pricing_type" : "fixed_price",
        "local_price": {
          "currency": "USDT",
          "amount" : 50.00,
        },
        "metadata": {
          "customer_id": "${widget.userInfo["id"]}",
          "customer_name": "${widget.userInfo["userName"]}"
        },
        "redirect_url": "${AppConfig.DOMAIN}/storedata/user?status=${int.parse("1")}&userId='${int.parse("${userId}")}",
        "cancel_url": "${AppConfig.DOMAIN}",
      }),
      headers: headers
    );



    var data = jsonDecode(request.body)["data"];

    if (request.statusCode == 201) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DoPayment(
          userInfo: widget.userInfo,
          bitcoinWalletID: "${data["addresses"]["bitcoin"]}",
          bitCoinAmount:"${ data["pricing"]["bitcoin"]["amount"]}",
          usdAmount: "${data["pricing"]["local"]["amount"]}",
          successURL: "${data["redirect_url"]}",
          errorURL: "${data['cancel_url']}",
      )),);
      print("this is payment success === ");
    }
    else {
      print("this is payment error ==== ${request.reasonPhrase}");
    }

    setState(() =>isLoading = false);

  }

}
