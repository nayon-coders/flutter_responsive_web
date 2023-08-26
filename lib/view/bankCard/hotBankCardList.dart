import 'package:flutter/material.dart';

class HotBankCardList extends StatefulWidget {
  const HotBankCardList({Key? key}) : super(key: key);

  @override
  State<HotBankCardList> createState() => _HotBankCardListState();
}

class _HotBankCardListState extends State<HotBankCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Hot Bank Card List"),),
    );
  }
}
