import 'package:flutter/material.dart';
import 'package:rakibproject1/responsive/responsive.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/utility/colors.dart';
import 'package:rakibproject1/view/auth/login.dart';

import '../home/dashboard.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final user = TextEditingController();
  final jabber = TextEditingController();
  final pass = TextEditingController();
  final Cpass = TextEditingController();
  final invitedCode = TextEditingController();

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
                  Text("${AppConfig.APP_NAME}",
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text("Please sign Up",
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: user,
                    decoration: InputDecoration(
                      hintText: "User Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v){
                      if(v!.isEmpty){
                        return "Filed must not be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: jabber,
                    decoration: InputDecoration(
                      hintText: "Jabber",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      prefixIcon: Icon(Icons.ac_unit_sharp),
                    ),
                    validator: (v){
                      if(v!.isEmpty){
                        return "Filed must not be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: pass,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: "Password",
                      prefixIcon: Icon(Icons.key),
                    ),
                    validator: (v){
                      if(v!.isEmpty){
                        return "Filed must not be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: Cpass,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: "Confirm Password",
                      prefixIcon: Icon(Icons.key),
                    ),
                    validator: (v){
                      if(v!.isEmpty){
                        return "Filed must not be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: ()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashBoard()), (route) => false),
                    child: Container(
                      width: Responsive.isMobile(context)? size.width*.60 : size.width*.40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text("SignUp",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white
                        ),
                      )),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextButton(onPressed: ()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false), child: Text("I have an account. Login"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
