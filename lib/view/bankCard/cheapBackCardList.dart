import 'package:flutter/material.dart';

class CheapBankCardList extends StatefulWidget {
  const CheapBankCardList({Key? key}) : super(key: key);

  @override
  State<CheapBankCardList> createState() => _CheapBankCardListState();
}

class _CheapBankCardListState extends State<CheapBankCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Cheap Bank Card List"),),
    );
  }
}
