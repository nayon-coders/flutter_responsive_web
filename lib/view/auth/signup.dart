import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rakibproject1/controller/sharedPrefarance.dart';
import 'package:rakibproject1/responsive/responsive.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/utility/colors.dart';
import 'package:rakibproject1/view/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:rakibproject1/view/auth/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      body: SingleChildScrollView(
        child: Column(
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

                    Text("Please sign Up",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20,),
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
                      onTap: (){


                        _signUp();


                      },
                      child: Container(
                        width: Responsive.isMobile(context)? size.width*.60 : size.width*.40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: isLoading ? CircularProgressIndicator(strokeWidth: 1, color: Colors.white,) :  Text("SignUp",
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
      ),
    );
  }

  bool showError = false;
  bool isLoading = false;

  _signUp() async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    Random random = new Random();
    int randomNumber = random.nextInt(100); // from 0 upto 99 included

    var userInfo = {
      "userName" : user.text,
      "password" : pass.text,
      "jabber" : jabber.text,
      "id" : randomNumber.toString()
    };
    print("info ==== ${user.text}");
    print("info ==== ${jabber.text}");
    print("info ==== ${pass.text}");
    var res = await http.post(Uri.parse(AppConfig.SIGNUP),
        body: jsonEncode({
          "user_name" : user.text,
          "jabber" : jabber.text,
          "password" : pass.text,
          "status" : 0
        }),
        headers: {
          "Content-Type": "application/json"
        }
    );
    print("state ==== ${res.statusCode}");
    print("state ==== ${res.body}");
    if(res.statusCode == 200){
      isLoading = false;
      //SaveData.storeAuthData(jsonDecode(res.body));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>RegistrationFee(userInfo: userInfo)), (route) => false);
    }else{
      setState(() {
        showError = true;
        isLoading = false;
      });
    }
  }
}
