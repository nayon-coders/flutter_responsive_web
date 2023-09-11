import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:rakibproject1/responsive/responsive.dart';
import 'package:rakibproject1/utility/colors.dart';
import 'package:rakibproject1/view/auth/signup.dart';
import 'package:rakibproject1/view/home/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:rakibproject1/viewController/loading.dart';
import '../../controller/sharedPrefarance.dart';
import '../../utility/appConfig.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final email = TextEditingController();
  final pass = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

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
                  Text("Please sign in",
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                showError ? Container(
                   padding: EdgeInsets.all(10),
                   margin: EdgeInsets.only(top: 20),
                   decoration: BoxDecoration(
                     color: Colors.red.shade50,
                     borderRadius: BorderRadius.circular(10)
                   ),
                   child:  Text(" $errorText ",
                    style: TextStyle(
                      color: Colors.red
                    ),
                   ),
                 ):SizedBox(),

                  SizedBox(height: 30,),
                  TextFormField(
                    controller: email,
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
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: ()=>_login(),
                    child: Container(
                      width: Responsive.isMobile(context)? size.width*.60 : size.width*.40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: isLoading ? CircularProgressIndicator(strokeWidth: 1, color: Colors.white,) : Text("Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white
                        ),
                      )),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextButton(onPressed: ()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Signup()), (route) => false), child: Text("I dont have an account. SignUp"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool showError = false;
  String? errorText = "";
  bool isLoading = false;
  _login() async{
    setState(() {
      isLoading = true;
    });
    var res = await http.post(Uri.parse(AppConfig.LOGIN),
      body: {
        "user_name" : email.text,
        "password" : pass.text
      }
    );
    print("login data ==== ${res.statusCode}");
    print("login data ==== ${res.body}");
    if(res.statusCode == 200){
      if(jsonDecode(res.body)["data"]["user"]["status"] == "1"){
        isLoading = false;
        SaveData.storeAuthData(jsonDecode(res.body));
        var sessionManager = SessionManager();
        await sessionManager.set("token", jsonDecode(res.body)["data"]["bearer_token"]);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashBoard()), (route) => false);
      }else{
        setState(() {
          isLoading = false;
          showError = true;
          errorText = "Account is not active. Wait until admin approval or contact with admin.";
        });
      }

    }else{
      setState(() {
        showError = true;
        isLoading = false;
        errorText = "User name/Password is increase";

      });
    }
  }
}
