import 'package:flutter/material.dart';
import 'package:rakibproject1/view/bankCard/bankCardList.dart';
import 'package:rakibproject1/view/bankCard/cheapBackCardList.dart';
import 'package:rakibproject1/view/bankCard/hotBankCardList.dart';

import '../view/setting/setting.dart';
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        )
    );
  }
}



