import 'dart:convert';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../responsive/responsive.dart';
import '../../utility/appConfig.dart';

class PurchasesList extends StatefulWidget {
  const PurchasesList({Key? key}) : super(key: key);

  @override
  State<PurchasesList> createState() => _PurchasesListState();
}

class _PurchasesListState extends State<PurchasesList> {


  //data date from api
  _getCardData()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("userId");
    var res = await http.get(Uri.parse(AppConfig.PUR_LIST),
      headers: {
        "Authorization" : "Bearer $token"
      },
    );

    print("this is response ==== ${res.body}");
    print("this is response ==== ${res.statusCode}");
    var data = jsonDecode(res.body)["data"]["card"];

    if(res.statusCode == 200){
      return data;
    }else{
      return data;
    }
  }



  Future? getCardPurList;
  bool isTabSingleTabb = false;



  final List<String> bankDropdown = [
    'OpenCards',
    'ClosedCards',
  ];
  String? selectedDropdown;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCardPurList = _getCardData();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      //margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: 700,
      ),
     child: FutureBuilder(
      future: getCardPurList,
      builder: (_, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.black,),),
          );
        }else if(snapshot.hasData){
          return SizedBox.expand(
            child: Column(
              children: [
                Container(
                  //width:Responsive.isMobile(context) ? size.width : size.width*.80,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  color: Colors.black,
                  child: Row(
                    children:  [
                      SizedBox(
                        width: size.width*.20,
                        child: Text("BASE",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width*.10,
                        child: Text("BIN",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),

                      SizedBox(
                        width: size.width*.10,
                        child: Text("EXP",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width*.20,
                        child: Text("Address",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width*.10,
                        child: Text("Price",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width*.15,
                        child: Text("Date",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Card Info",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child:  ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index){
                      return Container(
                        width:Responsive.isMobile(context) ? size.width : size.width*.80,
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        color: index.isOdd? Colors.grey.shade200 : Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width*.20,
                              child: Text("${snapshot.data[index]["base"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width*.10,
                              child:Text("${snapshot.data[index]["bin"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width*.10,
                              child: Text("${snapshot.data[index]["exp"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width*.20,
                              child: Text("${snapshot.data[index]["address"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width*.10,
                              child: Text("${snapshot.data[index]["price"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width*.10,
                              child: Text("${snapshot.data[index]["created_at"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Expanded(
                              //width: size.width*.20,
                                child: TextButton(
                                  onPressed: (){},
                                  child: Text("Check SSN"),
                                )
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),

          );
        }else{
          return Center( child: Text("Something went wrong"),);
        }
      },
    ),

    );
  }

  // void _showCCINfo(cardId) async{
  //   print("cardId === ${cardId}");
  //   var res = await http.post(Uri.parse(AppConfig.SINGLE_CARD),
  //     body: {
  //       "ccid" : "51157228"
  //     },
  //     headers: {
  //       "Access-Control-Allow-Origin": "*",
  //       'Accept': '*/*',
  //       "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
  //       "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
  //     },
  //   );
  //   var value = jsonDecode(res.body)["card"];
  //
  //   if(res.statusCode == ConnectionState.waiting){
  //     return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Car CC Information'),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 SizedBox(height: 50, width: 50, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.black,),),
  //                 SizedBox(height: 20,),
  //                 Text("Card info showing..."),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }else if(value["code"] == 1){
  //     print("this is ==== ${res.body}");
  //     return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Car CC Information'),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text('CC: ${value["hidden_cc"]}'),
  //                 Text('EXP: ${value["exp_month"]}/${value["exp_year"]}'),
  //                 Text('CVV: ${value["hidden_cvv"]}'),
  //                 Text('HOLDER: ${value["hidden_holder"]}'),
  //                 Text('BANK NAME: ${value["bin_base"]["bank_name"]}'),
  //                 Text('ZIP: ${value["zip"]}'),
  //                 Text('City: ${value["city"]}'),
  //                 Text('State: ${value["state"]}'),
  //                 Text('Country: ${value["country"]}'),
  //                 Text('DOB: ${value["cc_more_info"]["DOB"]}'),
  //                 Text('Email: ${value["cc_more_info"]["email"]}'),
  //                 Text('Phone: ${value["cc_more_info"]["phone"]}'),
  //                 Text('Address: ${value["cc_more_info"]["address"]}'),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             InkWell(
  //               onTap: ()=>checkSSN(value["id"]),
  //               child: Container(
  //                 padding: EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                     color: Colors.green,
  //                     borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: isCardCheck
  //                     ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white,),)
  //                     : Text("Check SSN",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             InkWell(
  //               onTap: ()=>Navigator.pop(context),
  //               child: Container(
  //                 padding: EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                     color: Colors.black,
  //                     borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Text("Close",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         );
  //       },
  //     );
  //   }else{
  //     print("Someting went wrong");
  //   }
  //
  // }

  bool isCardCheck = false;
  checkSSN(id) async{
    print("id====$id");
    var res = await http.post(Uri.parse(AppConfig.CHECK_CARD),
      headers: {
        "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
        "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
      },
      body: jsonEncode({
        "ccid" : 50537727,
        "checkerid" : "4check simple"
      })
    );
    print("res.body ==== ${res.body}");
    print("res.body ==== ${res.statusCode}");
    if(res.statusCode == 200){

    }

  }
}
