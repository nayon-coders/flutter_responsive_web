import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:rakibproject1/controller/apiController.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/utility/colors.dart';
import 'package:rakibproject1/view/balance/addBalance.dart';
import 'package:rakibproject1/view/bankCard/bankCardList.dart';
import 'package:rakibproject1/view/bankCard/cheapBackCardList.dart';
import 'package:rakibproject1/view/bankCard/hotBankCardList.dart';
import 'package:rakibproject1/view/setting/setting.dart';
import 'package:shimmer/shimmer.dart';

import '../../Models/balanceModel.dart';
import '../balance/balanceRequest.dart';

class DashBoard extends StatefulWidget {
  final int pageIndex;
  final double? amount;
  const DashBoard({Key? key, this.pageIndex = 0, this.amount}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final PageController _pageController = PageController();
  Future<BalanceModel>? _getBalance;
  double? amount;

  int currentPage = 0;
  final List<Widget> pages = [
    BankCardList(),
    HotBankCardList(),
    CheapBankCardList(),
    Setting(),
    Setting(),
    Setting(),

    //
    AddBalance(),//6

  ] ;


  final List<String> bankDropdown = [
    'Bank Card List',
    'Hot Bank Card List',
    'Cheap Bank Card List',
  ];
  String? selectedDropdown;



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    amount = widget.amount;
    pages.insert(7, BalanceRequest(amount: widget.amount,));
    currentPage = widget.pageIndex;
    _getBalance = ApiController.getBalance();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
     // drawer: const CustomDrawer(),

      // appBar: AppBar(
      //   actions: [
      //     TextButton(
      //       onPressed: (){},
      //       child: Text(""),
      //     )
      //   ],
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: 50,
              padding: EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: AppColors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   FutureBuilder<BalanceModel>(
                      future: _getBalance,
                      builder: (context, snapshot) {
                       if(snapshot.connectionState == ConnectionState.waiting){
                         return Shimmer.fromColors(
                           highlightColor: Colors.white,
                           baseColor: Colors.grey,
                           child: Container(
                             width: 300,
                             height: 15,
                             color: Colors.white,
                           ),
                         );
                       }else if(snapshot.hasData){
                         return   SizedBox(
                           width: size.width*.60,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               RichText(text: TextSpan(
                                   children: [
                                     TextSpan(text: "Blance : ",
                                         style: TextStyle(
                                             fontSize: 16,
                                             fontWeight: FontWeight.w600,
                                             color: Colors.white
                                         )
                                     ),
                                     TextSpan(text: "${snapshot.data?.balanceInUsd} | ",
                                         style: TextStyle(
                                             fontSize: 14,
                                             fontWeight: FontWeight.w400,
                                             color: Colors.purple
                                         )
                                     ),
                                     TextSpan(text: "(${snapshot.data?.balanceInBtc})",
                                         style: TextStyle(
                                             fontSize: 14,
                                             fontWeight: FontWeight.w400,
                                             color: Colors.amber
                                         )
                                     ),
                                   ]
                               )),
                               Icon(Icons.currency_bitcoin, color: Colors.amber,size: 10,),
                               IconButton(onPressed: (){
                                 setState(() {
                                   currentPage = 6;
                                 });
                               }, icon: Icon(Icons.add, color: Colors.purple,))
                             ],
                           ),
                         );
                       }else{
                         return Text("Something wen worng",
                          style: TextStyle(
                            color: Colors.white
                          ),
                         );
                       }
                      }
                    ),
                 SizedBox(width: size.width*.30,
                  child: Row(
                    children: [
                      DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        style: TextStyle(
                            color: Colors.black
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Bank Cards',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        items: bankDropdown
                            .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ))
                            .toList(),
                        value: selectedDropdown,
                        onChanged: (String? value) {
                          setState(() {
                            selectedDropdown = value;
                            if(selectedDropdown == "Bank Card List"){
                              currentPage = 0;
                            }else if(selectedDropdown == "Hot Bank Card List"){
                              currentPage = 1;
                            }else if(selectedDropdown == "Cheap Bank Card List"){
                              currentPage = 2;
                            }else{
                              currentPage = 0;
                            }
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: 140,
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          // )
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.black,
                          ),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData:  MenuItemStyleData(
                            height: 40,
                            overlayColor: MaterialStatePropertyAll(Colors.black.withOpacity(0.4))
                        ),
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                currentPage = 3;
                              });
                              print( "currentPage === ${currentPage}");
                            },
                            child: Text("Purchases Card",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                currentPage = 4;
                              });
                            },
                            child: const Text("Rules",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                currentPage = 5;
                              });
                            },
                            child: const Text("Setting",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                 )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                width: size.width,
                height: size.height,
                color: AppColors.bg,
                child: pages[currentPage]
            )
            // Row(
            //   children: [
            //     // Expanded(
            //     //   flex: 1,
            //     //     child: SingleChildScrollView(
            //     //       child: Container(
            //     //         width: size.width,
            //     //         height: size.height,
            //     //         color: Colors.white,
            //     //         child: Column(
            //     //           children: [
            //     //             SizedBox(height: 20,),
            //     //             const Text("${AppConfig.APP_NAME}",
            //     //               style: TextStyle(
            //     //                 fontSize: 18,
            //     //                 fontWeight: FontWeight.bold
            //     //               ),
            //     //             ),
            //     //             SizedBox(height: 7,),
            //     //             const Text("Balance: \$0.00000098",
            //     //               style: TextStyle(
            //     //                   fontSize: 12,
            //     //                   fontWeight: FontWeight.w400
            //     //               ),
            //     //             ),
            //     //             SizedBox(height: 5,),
            //     //             const Text("Bitcoin: \$0.000000000098",
            //     //               style: TextStyle(
            //     //                   fontSize: 12,
            //     //                   fontWeight: FontWeight.w400
            //     //               ),
            //     //             ),
            //     //             SizedBox(height: 20,),
            //     //             buildSideMenuList(
            //     //               index: 0,
            //     //               icon: Icons.credit_card_sharp,
            //     //               title: "Bank Card List"
            //     //             ),
            //     //             buildSideMenuList(
            //     //                 index: 1,
            //     //                 icon: Icons.credit_card_sharp,
            //     //                 title: "Cheap Bank Card List"
            //     //             ),
            //     //             buildSideMenuList(
            //     //                 index: 2,
            //     //                 icon: Icons.credit_card_sharp,
            //     //                 title: "Hot Bank Card List"
            //     //             ),
            //     //             buildSideMenuList(
            //     //                 index: 3,
            //     //                 icon: Icons.shopping_cart_outlined,
            //     //                 title: "Purchases Card List"
            //     //             ),
            //     //             SizedBox(height: 5,),
            //     //             Divider(height: 1, color: Colors.grey,),
            //     //             SizedBox(height: 5,),
            //     //             buildSideMenuList(
            //     //                 index: 4,
            //     //                 icon: Icons.info,
            //     //                 title: "Rules"
            //     //             ),
            //     //             buildSideMenuList(
            //     //                 index: 5,
            //     //                 icon: Icons.perm_device_info,
            //     //                 title: "FQA"
            //     //             ),
            //     //             buildSideMenuList(
            //     //                 index: 8,
            //     //                 icon: Icons.attach_money,
            //     //                 title: "Balance"
            //     //             ),
            //     //             buildSideMenuList(
            //     //                 index: 7,
            //     //                 icon: Icons.settings,
            //     //                 title: "Setting"
            //     //             ),
            //     //
            //     //             Spacer(),
            //     //             const Center(
            //     //               child: Text("Version : 1.0",
            //     //                 style: TextStyle(
            //     //                   fontWeight: FontWeight.w500,
            //     //                   fontSize: 12,
            //     //                   color: AppColors.black,
            //     //                   fontStyle: FontStyle.italic,
            //     //                 ),
            //     //               ),
            //     //             ),
            //     //             SizedBox(height: 20,),
            //     //           ],
            //     //         ),
            //     //       ),
            //     //     )
            //     // ),
            //     Expanded(
            //       // flex: 4,
            //       // child: PageView(
            //       //   scrollDirection: Axis.vertical,
            //       //   physics: const NeverScrollableScrollPhysics(),
            //       //   controller: _pageController,
            //       //   children: [
            //       //     ...pages
            //       //   ],
            //       // ),
            //     child: Container(
            //         padding: EdgeInsets.all(10),
            //         width: size.width,
            //         height: size.height,
            //         color: AppColors.bg,
            //         child: pages[currentPage]
            //     )
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Container buildSideMenuList({required int index, required String title, required IconData icon}) {
    return Container(
                        color: currentPage == index? AppColors.black : Colors.white,
                        child: ListTile(
                          onTap: ()=>setState(() {
                            currentPage = index;
                          }),
                          title: Text("$title",
                            style: TextStyle(
                              fontWeight:  currentPage == index? FontWeight.w600: FontWeight.w400,
                              color:  currentPage == index? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          leading: Icon(icon, size: 15, color:  currentPage == index? Colors.white : Colors.grey,),
                          trailing: Icon(Icons.arrow_forward_ios, size: 15, color:  currentPage == index? Colors.white : Colors.grey),
                        ),
                      );
  }
}
