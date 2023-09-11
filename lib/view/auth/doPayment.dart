import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rakibproject1/controller/sharedPrefarance.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/utility/colors.dart';
import 'package:http/http.dart' as http;
import '../home/dashboard.dart';

class DoPayment extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final dynamic bitcoinWalletID;
  final dynamic bitCoinAmount;
  final dynamic usdAmount;
  final dynamic successURL;
  final dynamic errorURL;
  const DoPayment({Key? key,
    required this.userInfo,
    this.bitcoinWalletID,
    this.bitCoinAmount,
    this.usdAmount,
    this.successURL,
    this.errorURL,
  }) : super(key: key);

  @override
  State<DoPayment> createState() => _DoPaymentState();
}

class _DoPaymentState extends State<DoPayment> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("url === ${widget.successURL}");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Registration Fee with Bitcoin",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: size.width,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3,),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: const Text("Remember that you can use this address for replenishment only once. If you make more than 1 transaction to this address, then we cannot guarantee that all payments will be credited. And once your payment is complete, you will redirect to Login screen and wait until Admin Approval",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                    fontSize: 16
                ),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bitcoin Address",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          Clipboard.setData(new ClipboardData(text: "${widget.bitcoinWalletID}"));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Copy: ${widget.bitcoinWalletID}"),
                            duration: Duration(milliseconds: 3000),
                            backgroundColor: Colors.green,
                          ));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: size.width*.40,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    topLeft: Radius.circular(5)
                                ),
                                border: Border.all(width: 1, color: Colors.black54),
                              ),
                              child: Align(alignment: Alignment.centerLeft, child: Text("${widget.bitcoinWalletID}")),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                    topRight: Radius.circular(5)
                                ),
                                border: Border.all(width: 1, color: Colors.black54),
                              ),
                              child: Center(

                                child: Text("Copy",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),
                      const Text("Amount in BTC",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          Clipboard.setData(ClipboardData(text: "${widget.bitCoinAmount}"));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Amount Copy: ${widget.bitCoinAmount}"),
                            duration: const Duration(milliseconds: 3000),
                            backgroundColor: Colors.green,
                          ));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: size.width*.40,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    topLeft: Radius.circular(5)
                                ),
                                border: Border.all(width: 1, color: Colors.black54),
                              ),
                              child: Align(alignment: Alignment.centerLeft, child: Text("${widget.bitCoinAmount} BTC")),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                    topRight: Radius.circular(5)
                                ),
                                border: Border.all(width: 1, color: Colors.black54),
                              ),
                              child: const Center(
                                child: Text("Copy",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20,),
                QrImage(data: "${widget.bitcoinWalletID}", size: 230,),
                SizedBox(width: 20,),
                SizedBox(
                  width: size.width*.20,
                  child: Center(
                    child: Text("You can also pay your bill using this QR code. It is needed to pay through mobile bitcoin wallets.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),

              ],
            ),

            SizedBox(height: 30,),
            const Text("Payment should appear within 15 minutes after payment. The payment is credited after 3 network confirmations.",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            SizedBox(height: 20,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: size.width*.20,
                        child: const Text("USDT Amount",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(":"),
                      SizedBox(width: 20,),
                      Text("${widget.usdAmount}",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Divider(height: 1, color: Colors.grey,),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: size.width*.20,
                        child: const Text("Loaded BTC	",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(":"),
                      SizedBox(width: 20,),
                      Text("${widget.bitCoinAmount}",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }




}
