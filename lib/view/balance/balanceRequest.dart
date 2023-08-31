import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakibproject1/controller/apiController.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Models/paymentStatusModel.dart';


class BalanceRequest extends StatefulWidget {
  final double? amount;
  const BalanceRequest({Key? key, this.amount}) : super(key: key);

  @override
  State<BalanceRequest> createState() => _BalanceRequestState();
}

class _BalanceRequestState extends State<BalanceRequest> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPaymentStatus = ApiController.paymentStatusCheck();
  }

  Future<PaymentSatatusModel>? _getPaymentStatus;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    final key = new GlobalKey<ScaffoldState>();

    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: FutureBuilder<PaymentSatatusModel>(
          future: _getPaymentStatus,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: SizedBox(height: 40, width: 40, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.black,),));
            }else if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text("Top up balance with Bitcoin",
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
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Remember that you can use this address for replenishment only once. If you make more than 1 transaction to this address, then we cannot guarantee that all payments will be credited.",
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
                                  Clipboard.setData(new ClipboardData(text: "${snapshot.data!.wallet}"));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Copy: ${snapshot.data!.wallet}"),
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
                                    child: Align(alignment: Alignment.centerLeft, child: Text("${snapshot.data!.wallet}")),
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
                            Text("Amount in BTC",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                              ),
                            ),
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                Clipboard.setData(new ClipboardData(text: "${widget.amount!*0.000037}"));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Amount Copy: ${widget.amount!*0.000037}"),
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
                                    child: Align(alignment: Alignment.centerLeft, child: Text("${widget.amount!*0.000037} btc")),
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
                          ],
                        ),
                      ),
                      SizedBox(width: 20,),
                      QrImage(data: "${snapshot.data?.wallet}", size: 230,),
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
                  Text("Payment should appear within 15 minutes after payment. The payment is credited after 3 network confirmations.",
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
                              child: Text("State",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(":"),
                            SizedBox(width: 20,),
                            Text("${snapshot.data?.state}",
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
                              child: Text("TXID",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(":"),
                            SizedBox(width: 20,),
                            Text("${snapshot.data?.txid}",
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
                              child: Text("Loaded BTC	",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(":"),
                            SizedBox(width: 20,),
                            Text("${snapshot.data?.loaded}",
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
                              child: Text("Time Left	",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(":"),
                            SizedBox(width: 20,),
                            Text("${snapshot.data?.timeLeft} - minutes left to finish payment",
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
              );
            }else{
              return Center(child: Text("Data Error..."),);
            }

          }
        ),
      ),
    );
  }
}
