import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rakibproject1/controller/apiController.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/view/home/dashboard.dart';

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
                          createPayment();

                        },
                        child: Container(
                          width: size.width*.20,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: isDataSubmit
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
  createPayment() async{
    setState(() =>isDataSubmit = true);
    if(selectedPaymentOption != null && amount.text.isNotEmpty){
      print("selectedPaymentOption   === $selectedPaymentOption");
      var res = await http.post(Uri.parse(AppConfig.PAYMENT_REQUEST),
        body: jsonEncode({
          "method" : "bitcoin",
          "amount" : amount.text
        }),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
          "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
        },
      );
      print("object === ${res.statusCode}");
      print("object === ${res.body}");
      if(res.statusCode == 200){
        if(jsonDecode(res.body)["code"] == 5){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(pageIndex: 7, amount: double.parse("${amount.text}"),)));
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${jsonDecode(res.body)["msg"]}"),
          duration: const Duration(milliseconds: 1500),
          backgroundColor: Colors.green,
        ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${jsonDecode(res.body)["detail"]}"),
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.red,
        ));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Select Payment method and Amount"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.red,
      ));
    }
    setState(() =>isDataSubmit = false);

  }

}
