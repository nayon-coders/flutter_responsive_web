import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:rakibproject1/view/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../responsive/responsive.dart';
import '../../utility/appConfig.dart';
import '../../utility/colors.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final _key = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final jabber = TextEditingController();

  _gerSingleUser()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString("token");
    var userId = _prefs.getString("userId");
    var res = await http.get(Uri.parse("${AppConfig.USER_PROFILE}"),
      headers: {
        "Authorization" : "Bearer $token"
      }
    );
    if(res.statusCode == 200){
      setState(() {
        username.text = jsonDecode(res.body)["data"]["user"]["user_name"];
        jabber.text = jsonDecode(res.body)["data"]["user"]["jabber"];
       // jabber.text = jsonDecode(res.body)["data"]["user"]["password"];
      });
    }
    return jsonDecode(res.body);
  }

  Future? getFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFuture = _gerSingleUser();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: Responsive.isMobile(context) ? EdgeInsets.only(left: 20, right: 20, top: 20) : EdgeInsets.only(left: 100, top: 20, right: 100),
      child: FutureBuilder(
        future: getFuture,
        builder: (context, snapshot) {
         if(snapshot.connectionState == ConnectionState.waiting){
           return Center(child: SizedBox(height: 100, width: 100, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.black,),));
         }else if(snapshot.hasData){
           return Form(
             key:  _key,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Setting",
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     TextButton(onPressed: ()=>logout(), child: Text("Logout"))
                   ],
                 ),
                 SizedBox(height: 20,),
                 TextFormField(
                   controller: username,
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
                   controller: password,
                   decoration: InputDecoration(
                     hintText: "Password",
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(5),
                     ),
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
                     if(_key.currentState!.validate()){
                       _saveChanges();
                     }
                   },
                   child: Container(
                     width: Responsive.isMobile(context)? size.width*.60 : size.width*.40,
                     height: 50,
                     decoration: BoxDecoration(
                       color: AppColors.black,
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Center(
                         child: isLoading ? CircularProgressIndicator(strokeWidth: 1, color: Colors.white,) :  Text("Save Changes",
                           style: TextStyle(
                               fontWeight: FontWeight.w600,
                               color: AppColors.white
                           ),
                         )),
                   ),
                 ),
               ],
             ),
           );
         }else{
           return const Center(child: Text("Something went wrong"),);
         }
        }
      )
    );
  }


  bool isLoading = false;
  _saveChanges() async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("userId");
    setState(() {
      isLoading = true;
    });
    var res = await http.post(Uri.parse("${AppConfig.UPDATE_USER}/$userId/update"),
        body: jsonEncode({
          "user_name" : username.text,
          "jabber" : jabber.text,
          "password" : password.text,
          "status" : 1,
          "email" : "email"
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization" : "Bearer $token"
        }
    );
    print("state ==== ${res.statusCode}");
    print("state ==== ${res.body}");
    if(res.statusCode == 200){
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Profile updated."),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
    }else{
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong."),
          duration: Duration(milliseconds: 3000),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  logout() async{
    var sessionManager = SessionManager();
    sessionManager.destroy();

    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove("token");
    _pref.remove("userId");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
  }

}
