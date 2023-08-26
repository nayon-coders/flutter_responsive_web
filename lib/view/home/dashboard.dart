import 'package:flutter/material.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/utility/colors.dart';
import 'package:rakibproject1/view/bankCard/bankCardList.dart';
import 'package:rakibproject1/view/bankCard/cheapBackCardList.dart';
import 'package:rakibproject1/view/bankCard/hotBankCardList.dart';
import 'package:rakibproject1/view/setting/setting.dart';
import 'package:rakibproject1/viewController/appDrawer.dart';

import '../../responsive/responsive.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final PageController _pageController = PageController();

  int currentPage = 0;
  final List<Widget> pages = [
    BankCardList(),
    CheapBankCardList(),
    HotBankCardList(),
    Setting(),
  ] ;




  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
     // drawer: const CustomDrawer(),

      body: Column(
        children: [
          Row(
            children: [ 
              Expanded(
                flex: 1,
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Text("${AppConfig.APP_NAME}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 20,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network("https://cdn-icons-png.flaticon.com/512/3135/3135715.png", 
                              height: 100, width: 100, fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("User Name",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 7,),
                          Text("Balance: \$0.00000098",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text("Bitcone: \$0.000000000098",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          SizedBox(height: 20,),
                          buildSideMenuList(
                            index: 0,
                            icon: Icons.credit_card_sharp,
                            title: "Bank Card List"
                          ),
                          buildSideMenuList(
                              index: 1,
                              icon: Icons.credit_card_sharp,
                              title: "Cheap Bank Card List"
                          ),
                          buildSideMenuList(
                              index: 2,
                              icon: Icons.credit_card_sharp,
                              title: "Hot Bank Card List"
                          ),
                          buildSideMenuList(
                              index: 3,
                              icon: Icons.shopping_cart_outlined,
                              title: "Purchases Card List"
                          ),
                          SizedBox(height: 5,),
                          Divider(height: 1, color: Colors.grey,),
                          SizedBox(height: 5,),
                          buildSideMenuList(
                              index: 4,
                              icon: Icons.info,
                              title: "Rules"
                          ),
                          buildSideMenuList(
                              index: 5,
                              icon: Icons.perm_device_info,
                              title: "FQA"
                          ),
                          buildSideMenuList(
                              index: 8,
                              icon: Icons.attach_money,
                              title: "Balance"
                          ),
                          buildSideMenuList(
                              index: 7,
                              icon: Icons.settings,
                              title: "Setting"
                          ),

                          Spacer(),
                          Center(
                            child: Text("Version : 1.0",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppColors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  )
              ),
              Expanded(
                flex: 4,
                // child: PageView(
                //   scrollDirection: Axis.vertical,
                //   physics: const NeverScrollableScrollPhysics(),
                //   controller: _pageController,
                //   children: [
                //     ...pages
                //   ],
                // ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: size.width,
                  height: size.height,
                  color: AppColors.bg,
                  child: pages[currentPage]
              )
              )
            ],
          )
        ],
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
