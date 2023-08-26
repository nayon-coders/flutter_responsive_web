import 'package:flutter/material.dart';

class BankCardList extends StatefulWidget {
  const BankCardList({Key? key}) : super(key: key);

  @override
  State<BankCardList> createState() => _BankCardListState();
}

class _BankCardListState extends State<BankCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Bank Card List"),),
    );
  }
}
