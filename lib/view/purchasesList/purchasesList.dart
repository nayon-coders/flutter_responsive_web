import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

import '../../utility/appConfig.dart';

class PurchasesList extends StatefulWidget {
  const PurchasesList({Key? key}) : super(key: key);

  @override
  State<PurchasesList> createState() => _PurchasesListState();
}

class _PurchasesListState extends State<PurchasesList> {


  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;
  var random = new Random();
  List<Map<String, dynamic>> temps = [];
  List apiData = [];
  List<Map<String, dynamic>> _generateData({List? apiData}) {
    print("apiData ==== $apiData");
    for (var data in apiData!) {
      print("_generateData ==== $data");
      temps.add(
          {
            "seller": data["seller_tag"],
            "base": data["seller_db"]["part_name"],
            "CVR": data["crv"],
            "BIN": data["hidden_cc"],
            "exp": "${data["exp_month"]}/${data["exp_year"]}",
            "info": "Info",
            "zip": data["zip"],
            "state": data["state"],
            "city": data["city"],
            "country": data["country"],
            "price": data["price"],
            "buy" : data["id"]

          }
      );

    }
    print("temps ========== ${temps}");
    return temps;

    // ignore: unused_local_variable

  }

  _initializeData() async {
    _mockPullData();
  }

  //data date from api
  _getCardData()async{
    var res = await http.post(Uri.parse(AppConfig.PURCHASE_LIST),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
        "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
      },
    );

    if(res.statusCode == 200){
      var data = jsonDecode(res.body)["results"];
      //print("data ==== $data");
      for (var data in data) {
        setState(() {
          apiData.add(data);
        });
      }

      //add to the temps list the table
      _generateData(apiData: apiData);

      //after add data in to the table then call _initializeData()
      _initializeData();
      return apiData;
    }else{
      return apiData;
    }
  }


  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);
    setState(() => _isLoading = true);
    _sourceOriginal.clear();
    _sourceOriginal.addAll(temps);
    _sourceFiltered = _sourceOriginal;
    _total = _sourceFiltered.length;
    _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
    setState(() => _isLoading = false);
  }

  _resetData({start: 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
    _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
            .toString()
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
            .toList();
      }
      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  bool isTabSingleTabb = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _headers = [
      DatatableHeader(
          text: "Seller",
          value: "seller",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Base",
          value: "base",
          show: true,
          flex: 6,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "CVR",
          value: "CVR",
          show: true,

          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "BIN",
          value: "BIN",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "EXP",
          value: "exp",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Info",
          value: "info",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),

      DatatableHeader(
          text: "zip",
          value: "zip",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),

      DatatableHeader(
          text: "City",
          value: "city",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Country",
          value: "country",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Price",
          value: "price",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Buy",
          value: "buy",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return TextButton(
              onPressed: (){

              },
              child: Text("View CCN Details"),
            );

          },
          textAlign: TextAlign.left),

    ];
    _initializeData();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(120.0),
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      Text(
                        'Website',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Tutorial',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Review',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      Text('https://flutter.dev/'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Flutter'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('5*'),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      Text('https://dart.dev/'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Dart'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('5*'),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      Text('https://pub.dev/'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Flutter Packages'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('5*'),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
