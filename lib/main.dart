import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:rakibproject1/view/auth/login.dart';
import 'package:rakibproject1/view/home/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.


  var token;
  bool loading = false;
  getToke()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
     setState(() {
       token = _pref.getString("token");
     });
    print("token ==== $token");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToke();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProMarket0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token != null ? DashBoard() : Login(),
    );
  }
}
