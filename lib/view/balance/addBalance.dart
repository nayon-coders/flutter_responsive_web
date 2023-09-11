import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rakibproject1/controller/apiController.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/view/balance/balanceRequest.dart';
import 'package:rakibproject1/view/home/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBalance extends StatefulWidget {
  const AddBalance({Key? key}) : super(key: key);

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {

  final amount = TextEditingController();

  final List<String> paymentOptionList = [
    'Bitcoin',
  ];
  String? selectedPaymentOption;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add balance",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 50,
                        width: size.width*.50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            style: TextStyle(
                                color: Colors.black
                            ),
                            isExpanded: true,
                            hint: Text(
                              'Select Payment Method',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            items: paymentOptionList
                                .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedPaymentOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedPaymentOption = value;
                              });
                            },
                            buttonStyleData:  ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 30,
                              width: size.width*.50,
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              // )
                            ),
                            menuItemStyleData:  MenuItemStyleData(
                                height: 40,
                               // overlayColor: MaterialStatePropertyAll(Colors.black.withOpacity(0.4))
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: amount,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1, color: Colors.grey,
                            )
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "\$500",
                        ),
                        validator: (v){
                          if(v!.isEmpty){
                            return "Amount must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30,),
                      InkWell(
                        onTap: (){
                          isLoading?null: makePayment();

                        },
                        child: Container(
                          width: size.width*.20,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: isLoading
                              ? Center(
                            child: Text("Loading...",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                              ),
                            ),
                          )
                              :Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.monetization_on, color: Colors.purple,),
                              SizedBox(width: 10,),
                              Text("Create Payment",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Text("Funds are added automatically after 2 confirmations. We give you a new address for every deposit. Our main rule is: 1 address = 1 transaction. If you violate this rule, funds may not be credited.The maximum amount of replenishment at a time is \$5000, the minimum is \410.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        letterSpacing: 1,
                        wordSpacing: 0.9
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }



  bool isDataEmpty = false;
  bool isDataSubmit = false;
  bool isLoading = false;
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
            "amount" : amount.text,
          },
          "metadata": {
            "customer_id": "${userId}",
            "customer_name": "${userName}"
          },
          "redirect_url": "${AppConfig.DOMAIN}/storedata/user?amount='${double.parse("${amount.text}")}'&userId='${int.parse("$userId")}'",
          "cancel_url": "${AppConfig.DOMAIN}",
        }),
        headers: headers
    );



    var data = jsonDecode(request.body)["data"];

    if (request.statusCode == 201) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>BalanceRequest(
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
