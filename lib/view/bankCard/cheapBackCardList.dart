import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cardJson.dart';
import '../../controller/apiController.dart';
import '../../responsive/responsive.dart';
import '../home/dashboard.dart';

class CheapBankCardList extends StatefulWidget {
  const CheapBankCardList({Key? key}) : super(key: key);

  @override
  State<CheapBankCardList> createState() => _CheapBankCardListState();
}

class _CheapBankCardListState extends State<CheapBankCardList> {
  //price form admin
  double priceFromAdmin = 20;
  double userBankBalance = 50.10;

  getAdminAmount()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      priceFromAdmin = double.parse("${_pref.getString("card_amount")}");
    });
    print(" priceFromAdmin ==== ${priceFromAdmin}");
  }

  _singleUerData()async{
    var res = await ApiController.gerSingleUser();
    setState(() {
      userBankBalance = double.parse("${res["data"]["user"]["balance"]}");
    });
    print("userBankBalance === ${userBankBalance}");
  }
  _updateUserBalanceOnceBuyComplete(updatedbalance)async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("userId");
    setState(() {
      isLoading = true;
    });
    var res = await http.post(Uri.parse("${AppConfig.OWN_BASE_URL}/user/${userId}/balance/minus"),
        body:jsonEncode( {
          "balance" : updatedbalance
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization" : "Bearer $token"
        }
    );
    print("state ==== ${res.statusCode}");
    print("state ==== ${res.body}");
    print("updatedbalance ==== ${userBankBalance}");
    if(res.statusCode == 200){
      setState(() {
        isLoading = false;
      });
      _singleUerData();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Balance is updated."),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
    }else{
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Balance Not Updated"),
          duration: Duration(milliseconds: 3000),
          backgroundColor: Colors.red,
        ));
      });
    }
  }


  //data date from api
  _getCardData()async{
    setState(() {
      isLoading = true;
    });
    var res = await http.post(Uri.parse(AppConfig.CARD_LIST),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
          "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
        },
      body: jsonEncode({
        "cheap" : "yes"
      })
    );
    var data = jsonDecode(res.body);

    setState(() {
      isLoading = false;
    });
    return data;
  }





  bool isTabSingleTabb = false;
  Future ? getcardtFuture;
  @override
  void initState() {
    super.initState();
    //getcardtFuture = _getCardData();
    getAdminAmount();
    filterCard.addAll(CardListJson.cheapBankCardList);

    /// set headers

  }

  List buyIdes = [];
  bool isLoading = false;
  bool cardPur = false;
  _buy({
    required String card_id,
    required String seller,
    required String base,
    required String bin,
    required String expir,
    required String address,
    required String price,
  })async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("userId");
    print("data $card_id, $price, $userId, $token");
    print("user balance ==== $userBankBalance");
    setState(() {
      isLoading = true;
    });
    if(userBankBalance > double.parse("${price}")){
      var res = await http.post(Uri.parse("https://iahhealthservice.com/nyn/public/api/card/purchase"),
          body: {
            "card_id" : card_id,
            "user_id" : userId,
            "seller" : seller,
            "base" : base,
            "bin" : bin,
            "exp" : expir,
            "address" : address,
            "price" : price
          },
          headers: {
            "Authorization" : "Bearer $token"
          }
      );
      print("buy response === ${res.statusCode}");
      print("buy response === ${res.body}");
      if(res.statusCode == 200){
        setState(() {
          userBankBalance= (userBankBalance - double.parse("${price}"));
          var afterPurcBalanace = (userBankBalance - double.parse("${price}"));
          _updateUserBalanceOnceBuyComplete(afterPurcBalanace);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Card successfully purchases."),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 5000),
        ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Try again."),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 5000),
        ));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You don't have enough balance."),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  //card id store
  List cardIds = [];

  List filterCard = [];
  bool isFilter = false;
  final bin = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final country = TextEditingController();
  final zip = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Cheap Bank Card List",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(width: 10,),
                isFilter ? Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: bin,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10, right: 10,),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                              ),
                              hintText: "bin"
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          controller: state,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                              ),
                              hintText: "State"
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          controller: city,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                              ),
                              hintText: "city"
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          controller: country,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                              ),
                              hintText: "Country"
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          controller: zip,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                              ),
                              hintText: "zip"
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        onTap: (){
                          isLoading ? null : setState((){
                            isLoading = true;
                            filterCard.clear();
                            for (var map in CardListJson.cheapBankCardList) {
                              if (map!["zip"] == zip.text || map!["hidden_cc"] == bin.text || map!["city"] == city.text || map!["zip"] == zip.text || map!["state"] == state.text || map!["country"] == country.text) {
                                filterCard.add(map);
                                print("CardListJson.bankCard[index] === ${filterCard}");
                                // your list of map contains key "id" which has value 3
                              }
                            }
                            isLoading = false;;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: Text("Filter",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Center(),
                Row(
                  children: [
                    TextButton(
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard())),
                      child: Text("Update Balance"),
                    ),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          if(isFilter){
                            isFilter = false;
                            bin.clear();
                            state.clear();
                            city.clear();
                            country.clear();
                            zip.clear();
                            filterCard.addAll(CardListJson.cheapBankCardList);
                          }else{
                            isFilter = true;
                          }

                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text("${isFilter? "Clear" : "Filter"}",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            Container(
              //width:Responsive.isMobile(context) ? size.width : size.width*.80,
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              color: Colors.black,
              child: Row(
                children:  [
                  SizedBox(
                    width: size.width*.15,
                    child: Text("Base",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width*.05,
                    child: Text("CVR",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width*.15,
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
                    child: Text("Exp",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),

                  SizedBox(
                    width: size.width*.10,
                    child: Text("ZIP",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width*.10,
                    child: Text("City",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width*.10,
                    child: Text("Country",
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
                  Expanded(
                    child: Text("Buy",
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

            isLoading ? Center(child: SizedBox(height: 100, width: 100, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.black,),),) : filterCard.isEmpty ? Center(child: Text("No card found"),):  Expanded(
              child:  ListView.builder(
                itemCount: filterCard.length,
                itemBuilder: (_, index){
                  var data = filterCard[index];

                  return Container(
                    width:Responsive.isMobile(context) ? size.width : size.width*.80,
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    color: index.isOdd? Colors.grey.shade200 : Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width*.15,
                          child: Text("${data["seller_db"]["part_name"]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                          ),
                        ),
                        SizedBox(
                            width: size.width*.05,
                            child:data["seller_db"]["rating"] == 5
                                ? Icon(Icons.wifi, color: Colors.blue,)
                                : data["seller_db"]["rating"] == 4
                                ? Icon(Icons.network_wifi_3_bar, color: Colors.blue,)
                                :data["seller_db"]["rating"] == 3
                                ?Icon(Icons.wifi_2_bar, color: Colors.blue,)
                                :Icon(Icons.wifi_1_bar, color: Colors.blue,)
                        ),
                        SizedBox(
                          width: size.width*.15,
                          child:Text("${data["hidden_cc"]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*.10,
                          child: Text("${data["exp_month"]}/${data["exp_year"]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*.10,
                          child: Text("${data["zip"]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*.10,
                          child: Text("${data["city"]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*.10,
                          child: Text("${data["country"]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*.10,
                          child: Text("${((double.parse("${data["price"]}")/100*priceFromAdmin) +  double.parse("${data["price"]}")).toStringAsFixed(2)}",
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
                              onPressed: ()=>isLoading ? false : _buy(
                                  card_id: data["id"].toString(),
                                  seller: "seller",
                                  base: data["seller_db"]["part_name"],
                                  bin: data["hidden_cc"],
                                  expir: "${data["exp_month"]}/${data["exp_year"]}",
                                  address: '${data["city"]}, ${data["state"]}, ${data["zip"]}, ${data["country"]}',
                                  price: "${((double.parse("${data["price"]}")/100*priceFromAdmin) +  double.parse("${data["price"]}")).toStringAsFixed(2)}"
                              ),
                              child: isLoading ? CircularProgressIndicator(strokeWidth: 1, color: Colors.black,) : Text("buy"),
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

      ),
      // child: FutureBuilder(
      //   future: getcardtFuture,
      //   builder: (_, snapshot){
      //     if(snapshot.connectionState == ConnectionState.waiting){
      //       return Center(
      //         child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.black,),),
      //       );
      //     }else if(snapshot.hasData){
      //       return SizedBox.expand(
      //         child: Column(
      //           children: [
      //             Container(
      //               //width:Responsive.isMobile(context) ? size.width : size.width*.80,
      //               padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      //               color: Colors.black,
      //               child: Row(
      //                 children:  [
      //                   SizedBox(
      //                     width: size.width*.15,
      //                     child: Text("Base",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: size.width*.05,
      //                     child: Text("CVR",
      //                       style: TextStyle(
      //                           fontSize: 15,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: size.width*.15,
      //                     child: Text("BIN",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: size.width*.10,
      //                     child: Text("Exp",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //
      //                   SizedBox(
      //                     width: size.width*.10,
      //                     child: Text("ZIP",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: size.width*.10,
      //                     child: Text("City",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: size.width*.10,
      //                     child: Text("Country",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: size.width*.10,
      //                     child: Text("Price",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   ),
      //                   Expanded(
      //                     child: Text("Buy",
      //                       style: TextStyle(
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.white
      //                       ),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ),
      //             Expanded(
      //               child:  ListView.builder(
      //                 itemCount: snapshot.data["results"].length,
      //                 itemBuilder: (_, index){
      //                   return Container(
      //                     width:Responsive.isMobile(context) ? size.width : size.width*.80,
      //                     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      //                     color: index.isOdd? Colors.grey.shade200 : Colors.white,
      //                     child: Row(
      //                       children: [
      //                         SizedBox(
      //                           width: size.width*.15,
      //                           child: Text("${snapshot.data["results"][index]["seller_db"]["part_name"]}",
      //                             style: TextStyle(
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.w400,
      //                                 color: Colors.black
      //                             ),
      //                           ),
      //                         ),
      //                     SizedBox(
      //                         width: size.width*.05,
      //                             child: snapshot.data["results"][index]["seller_db"]["rating"] == 5
      //                                 ? Icon(Icons.wifi, color: Colors.blue,)
      //                                 : snapshot.data["results"][index]["seller_db"]["rating"] == 4
      //                                 ? Icon(Icons.network_wifi_3_bar, color: Colors.blue,)
      //                                 :snapshot.data["results"][index]["seller_db"]["rating"] == 3
      //                                 ?Icon(Icons.wifi_2_bar, color: Colors.blue,)
      //                                 :Icon(Icons.wifi_1_bar, color: Colors.blue,)
      //                           ),
      //                         SizedBox(
      //                           width: size.width*.15,
      //                           child:Text("${snapshot.data["results"][index]["hidden_cc"]}",
      //                             style: TextStyle(
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.w400,
      //                                 color: Colors.black
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           width: size.width*.10,
      //                           child: Text("${snapshot.data["results"][index]["exp_month"]}/${snapshot.data["results"][index]["exp_year"]}",
      //                             style: TextStyle(
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.w400,
      //                                 color: Colors.black
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           width: size.width*.10,
      //                           child: Text("${snapshot.data["results"][index]["zip"]}",
      //                             style: TextStyle(
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.w400,
      //                                 color: Colors.black
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           width: size.width*.10,
      //                           child: Text("${snapshot.data["results"][index]["city"]}",
      //                             style: TextStyle(
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.w400,
      //                                 color: Colors.black
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           width: size.width*.10,
      //                           child: Text("${snapshot.data["results"][index]["country"]}",
      //                             style: TextStyle(
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.w400,
      //                                 color: Colors.black
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           width: size.width*.10,
      //                           child: Text("${((double.parse("${snapshot.data["results"][index]["price"]}")/100*priceFromAdmin) +  double.parse("${snapshot.data["results"][index]["price"]}")).toStringAsFixed(2)}",
      //                             style: TextStyle(
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.w400,
      //                                 color: Colors.black
      //                             ),
      //                           ),
      //                         ),
      //                         Expanded(
      //                           //width: size.width*.20,
      //                             child: TextButton(
      //                               onPressed: ()=>isLoading ? false : _buy(
      //                                 card_id: snapshot.data["results"][index]["id"].toString(),
      //                                 seller: "seller",
      //                                 base: snapshot.data["results"][index]["seller_db"]["part_name"],
      //                                 bin: snapshot.data["results"][index]["hidden_cc"],
      //                                 expir: "${snapshot.data["results"][index]["exp_month"]}/${snapshot.data["results"][index]["exp_year"]}",
      //                                 address: '${snapshot.data["results"][index]["city"]}, ${snapshot.data["results"][index]["state"]}, ${snapshot.data["results"][index]["zip"]}, ${snapshot.data["results"][index]["country"]}',
      //                                 price: "${((double.parse("${snapshot.data["results"][index]["price"]}")/100*priceFromAdmin) +  double.parse("${snapshot.data["results"][index]["price"]}")).toStringAsFixed(2)}"
      //                               ),
      //                               child: isLoading ? CircularProgressIndicator(strokeWidth: 1, color: Colors.black,) : Text("buy"),
      //                             )
      //                         )
      //                       ],
      //                     ),
      //                   );
      //                 },
      //               ),
      //             )
      //           ],
      //         ),
      //
      //       );
      //     }else{
      //       return Center( child: Text("Something went wrong"),);
      //     }
      //   },
      // ),
    );
  }

  var totalPrice = 0.00;


  double calculateTotalPrice(selectedItems) {
    double totalPrice = 0.0;
    for (var item in selectedItems) {
      setState(() {
        totalPrice += double.parse("${item["price"]}");
      });
    }
    return totalPrice;
    print("total price is ======---==== ${totalPrice}");
  }
  double calculateTotalPriceMinuse(selectedItems, index) {
    double totalPrice = 0.0;
    print("--------------- value ---------- ${index}");
    print(index);
    print("--------------- value ---------- ${selectedItems[index]}");

    setState(() {
      totalPrice = totalPrice - double.parse("${selectedItems[index]["price"]}");
    });
    return totalPrice;

    print("total price is ======---==== ${totalPrice}");
  }

}
