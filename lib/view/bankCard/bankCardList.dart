import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rakibproject1/Models/cardModels.dart';
import 'package:rakibproject1/utility/appConfig.dart';
import 'package:rakibproject1/view/home/dashboard.dart';
import 'package:responsive_table/responsive_table.dart';

import '../../Models/cardBuySuccessModel.dart';
import '../../viewController/loading.dart';

class BankCardList extends StatefulWidget {
  const BankCardList({Key? key}) : super(key: key);

  @override
  State<BankCardList> createState() => _BankCardListState();
}

class _BankCardListState extends State<BankCardList> {

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
    var res = await http.post(Uri.parse(AppConfig.CARD_LIST),
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
Future ? getcardtFuture;
  @override
  void initState() {
    super.initState();
    getcardtFuture = _getCardData();
    /// set headers
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
                setState(() {
                  buyIdes.add(value.toString());
                });
                buyCard();
                print("this is buy ===== ${value} \n $row");
              },
              child: Text("Buy"),
            );

          },
          textAlign: TextAlign.left),

    ];

  }

  List buyIdes = [];
  bool isLoading = false; 
  Future<CardByeSuccessModel> buyCard()async{
    AppLoading.showMyDialog(context);
    print("ides ==== $buyIdes");
    var res = await http.post(Uri.parse(AppConfig.CARD_BY),
      body: jsonEncode({
        "cards_ids": buyIdes,
        "cards_toopen_ids":buyIdes,
      }),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        "BIDENAUTH": AppConfig.API_KEY, // whatever headers you need(I add auth)
        "content-type": "application/json" // Specify content-type as JSON to prevent empty response body
      },
    );
    print("response ---- ${res.body}");
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${jsonDecode(res.body)["msg"]}"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(pageIndex: 8,)));

      return CardByeSuccessModel.fromJson(jsonDecode(res.body));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Balance is not enugh."),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.red,
      ));
      Navigator.pop(context);

      return CardByeSuccessModel.fromJson(jsonDecode(res.body));
    }
  }
  //card id store
  List cardIds = [];

  @override
  void dispose() {
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  //margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  constraints: BoxConstraints(
                    maxHeight: 700,
                  ),
                  child:ResponsiveDatatable(
                    headerDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    headerTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    ),
                    selectedDecoration: BoxDecoration(
                        color: Colors.grey.shade300
                    ),

                    title: TextButton.icon(
                      onPressed: () => {},
                      icon: Icon(Icons.table_rows_outlined),
                      label: Text("Bank Card list",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black
                        ),
                      ),
                    ),
                    reponseScreenSizes: [ScreenSize.xs],
                    actions: [
                      Row(
                        children: [
                          InkWell(
                            onTap:(){
                              buyIdes.clear();
                              for (var item in _selecteds) {
                                print("item === $item");
                                setState(() {
                                  buyIdes.add(item["buy"].toString());
                                });
                              }

                              buyCard();

                            },
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text("Buy All [\$${totalPrice}]",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Text("Filter",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                    headers: _headers,
                    source: _source,
                    selecteds: _selecteds,
                    showSelect: _showSelect,
                    autoHeight: false,
                    dropContainer: (data) {
                      print('_selecteds === ${_selecteds}');
                      return Center();
                      //return _DropDownContainer(data: data);
                    },
                    onChangedRow: (value, header) {
                      /// print(value);
                      /// print(header);
                    },
                    onSubmittedRow: (value, header) {
                      /// print(value);
                      /// print(header);
                    },
                    onTabRow: (value) {
                      print("one tab row === $value");
                      // setState(() {
                      //   isTabSingleTabb = true;
                      // });
                      // if (_selecteds.indexOf(value)!=true) {
                      //   setState((){ isTabSingleTabb = false;  _selecteds.add(value);  });
                      // } else {
                      //   setState(
                      //           (){isTabSingleTabb = true; _selecteds.removeAt(_selecteds.indexOf(value)); });
                      // }
                    },
                    onSort: (value) {

                      setState(() => _isLoading = true);

                      setState(() {
                        _sortColumn = value;
                        _sortAscending = !_sortAscending;
                        if (_sortAscending) {
                          _sourceFiltered.sort((a, b) =>
                              b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                        } else {
                          _sourceFiltered.sort((a, b) =>
                              a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                        }
                        var _rangeTop = _currentPerPage! < _sourceFiltered.length
                            ? _currentPerPage!
                            : _sourceFiltered.length;
                        _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                        _searchKey = value;

                        _isLoading = false;
                      });
                    },
                    expanded: _expanded,
                    sortAscending: _sortAscending,
                    sortColumn: _sortColumn,
                    isLoading: _isLoading,
                    onSelect: (value, item) {
                      print(" value   $value  $item ");
                      if (value!) {
                        setState((){
                          _selecteds.add(item);
                        });
                        if(_selecteds.isNotEmpty){
                         totalPrice = calculateTotalPrice(_selecteds);
                        }
                      } else {
                        setState(
                          (){
                            _selecteds.removeAt(_selecteds.indexOf(item));
                            totalPrice = totalPrice - double.parse("${item['price']}");
                          });

                      }
                    },
                    onSelectAll: (value) {
                      if (value!) {
                        setState(() => _selecteds = _source.map((entry) => entry).toList().cast());
                        if(_selecteds.isNotEmpty){
                          totalPrice = calculateTotalPrice(_selecteds);
                        }
                      } else {
                        setState(() => _selecteds.clear());
                        totalPrice = 0.0;
                      }
                    },
                    footers: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: const Text("Rows per page:"),
                      ),
                      if (_perPages.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<int>(
                            value: _currentPerPage,
                            items: _perPages
                                .map((e) => DropdownMenuItem<int>(
                              child: Text("$e"),
                              value: e,
                            ))
                                .toList(),
                            onChanged: (dynamic value) {
                              setState(() {
                                _currentPerPage = value;
                                _currentPage = 1;
                                _resetData();
                              });
                            },
                            isExpanded: false,
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child:
                        Text("$_currentPage - $_currentPerPage of $_total"),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                        ),
                        onPressed: _currentPage == 1
                            ? null
                            : () {
                          var _nextSet = _currentPage - _currentPerPage!;
                          setState(() {
                            _currentPage = _nextSet > 1 ? _nextSet : 1;
                            _resetData(start: _currentPage - 1);
                          });
                        },
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: _currentPage + _currentPerPage! - 1 > _total
                            ? null
                            : () {
                          var _nextSet = _currentPage + _currentPerPage!;

                          setState(() {
                            _currentPage = _nextSet < _total
                                ? _nextSet
                                : _total - _currentPerPage!;
                            _resetData(start: _nextSet - 1);
                          });
                        },
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      )
                    ],
                  ),
                ),
              ])),
    );
  }

  var totalPrice = 0.00;


  double calculateTotalPrice(selectedItems) {
    double totalPrice = 0.0;
    for (var item in selectedItems) {
      setState(() {
        totalPrice += double.parse("${item["price"]}");
      });
    }
    return totalPrice;
    print("total price is ======---==== ${totalPrice}");
  }
  double calculateTotalPriceMinuse(selectedItems, index) {
    double totalPrice = 0.0;
    print("--------------- value ---------- ${index}");
    print(index);
    print("--------------- value ---------- ${selectedItems[index]}");

    setState(() {
      totalPrice = totalPrice - double.parse("${selectedItems[index]["price"]}");
    });
    return totalPrice;

    print("total price is ======---==== ${totalPrice}");
  }

}
