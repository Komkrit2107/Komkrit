import 'dart:convert';
import 'dart:ffi';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:intl/number_symbols_data.dart';
import 'package:kritproduct/models/result_model.dart';
import 'package:kritproduct/models/user_model.dart';
import 'package:kritproduct/models/my_style.dart';
import 'package:kritproduct/widget/agentlookup.dart';
//import 'package:date_format/date_format.dart';
import 'package:kritproduct/widget/holdinglist.dart';
import 'package:kritproduct/widget/authen.dart';

class HoldingDatak extends StatefulWidget {
  final UserModel userModel;
  HoldingDatak({Key key, this.userModel}) : super(key: key);

  @override
  _HoldingDatakState createState() => _HoldingDatakState();
}

class _HoldingDatakState extends State<HoldingDatak> {
  // Field
  UserModel currentModel;
  String token, userID;
  String users, password;
  String userss;
  String customerName;
  Double totalaveragecost;
  Double totalMaketprice;
  List risklevels = [];

  List<ResultModel> resultModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    currentModel = widget.userModel;
    token = currentModel.token;
    token = 'Bearer $token';
    userID = currentModel.uSERID;
    users = currentModel.loginName;
    password = "123456";
    customerName = currentModel.fULLNAME;
    userss = currentModel.loginName;
    readData();
  }

  Future<void> readData() async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/summary/$userID';
    //String url = 'http://115.31.144.227:3009/api/wr/summary/$userID';
    //String url = 'http://10.211.55.4:3009/api/wr/summary/$userID';

    Map<String, String> headers = Map();
    headers['Authorization'] = token;

    http.Response response = await http.get(url, headers: headers);
    var result = json.decode(response.body);
    print('result ===>>> $result');

    var myResult = json.decode(response.body)['result'];
    // print('myResult = $myResult');

    for (var map in myResult) {
      // print('map ===>> $map');

      ResultModel resultModel = ResultModel.fromJson(map);
      // print('AvgCode ===>>> ${resultModel.avgCost}');
      setState(() {
        resultModels.add(resultModel);
      });
      print('resultModels.lenght ===>>>  ${resultModels.length}');
    }
  }

  Widget showProcess() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showProductItem(int index) {
    return Expanded(
      child: ListView.builder(
        //controller: scrollController,
        itemCount: resultModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return GestureDetector(
            child: Card(
              child: Row(
                children: <Widget>[
                  // showImage(index),
                  showText(index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget showBalanceUnit(int index) {
    double balanceUnit = resultModels[index].balanceUnit;
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7 - 50,
          child: Text(
            balanceUnit.toString(),
            //filterProductAllModels[index].title,
            style: TextStyle(color: MyStyle().red1),
          ),
        ),
      ],
    );
  }

  Widget showmarketPrice(int index) {
    double marketPrice = resultModels[index].marketPrice;
    return Row(
      children: <Widget>[
        Text(
          marketPrice.toString(),
          //'Price = ${filterProductAllModels[index].marketPrice.toString()}/Unit',
          //style: MyStyle().h3Style,
        ),
      ],
    );
    // return Text('na');
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 16.0,
      ),
      // color: Colors.grey,
      // height: MediaQuery.of(context).size.width * 0.5,
      width: MediaQuery.of(context).size.width * 0.7 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[showBalanceUnit(index), showmarketPrice(index)],
      ),
    );
  }

  Widget showNav(int index) {
    double marketPrice = resultModels[index].marketPrice;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            ':',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          myFormat(marketPrice, 'MarketPrice ='),
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }

  String myFormatint(int myDoubleint, String title) {
    NumberFormat numberFormat = NumberFormat('#');
    return numberFormat.format(myDoubleint);
  }

  String myFormat(double myDouble, String title) {
    NumberFormat numberFormat = NumberFormat('#,##0.0000');
    return numberFormat.format(myDouble);
  }

  String my2Format(double myDouble, String title) {
    NumberFormat numberFormat = NumberFormat('#,##0.00');
    return numberFormat.format(myDouble);
  }

  String myPercentFormat(double myPercent, String title) {
    myPercent = myPercent / 100;
    NumberFormat numberFormat = NumberFormat('##.00%');
    return numberFormat.format(myPercent);
  }

// Convert String date to Date
  String myFormatdate(String myDate, String title) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MMM-yyyy');
    String formatted = formatter.format(now);
    return formatted;
  }

  Widget showDateAs(int index) {
    // String dataDate = resultModels[index].dataDate;
    // DateTime todayDate = DateTime.parse(dataDate);
    // String formdate = formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'Nav Date/ณ วันที่',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0, color: MyStyle().red1),
          ),
        ),
        Text("",
           
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }
// ตัวอย่าง

  Future<int> sumStream(Stream<int> stream) async {
    var sum = 0;
    await for (var value in stream) {
      sum += value;
    }
    return sum;
  }

  Widget showAmcName(int index) => Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Text(
              resultModels[index].amcName,
              style: TextStyle(
                color: MyStyle().red1,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );

  Widget showFundName(int index) => Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Text(
              resultModels[index].fundCode,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      );

  Widget showFundGName(int index) => Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Text(
              resultModels[index].fundNameT,
              style: TextStyle(
                color: MyStyle().red2,
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      );

  Widget showFundGroub(int index) => Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Text(
              resultModels[index].fGroupCode,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );

  Widget showCustomerName() {
    //EdgeInsets.fromLTRB(1.0, 50.0, 1.0, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          '$customerName',
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 12.0,
            color: MyStyle().colorblack,
          ),
        ),
      ],
    );
  }

  Widget showTitle2() {
    EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 1.0);
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Fund  ',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 16.0,
            color: MyStyle().deepPurple900,
          ),
        ),
      ],
    );
  }

  Future<void> checkExittoMain() async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
//String url = 'http://115.31.144.227:3009/api/user/login';
//String url = 'http://10.211.55.4:3009/api/user/login';
    try {
      // // Dio Type
      Map<String, dynamic> map = Map();
      map['email'] = userss;
      map['password'] = password;
      Map<String, String> headers = Map();
      headers['Content-Type'] = 'application/json';
      var response = await http.post(url, body: map);
      // print('StatusCode ===>> ${response.statusCode}');
      if (response.statusCode == 401) {
        print('Login False');
      } else {
        var result = json.decode(response.body);
        // print('result = $result');
        UserModel userModel = UserModel.fromJson(result);
        MaterialPageRoute route = MaterialPageRoute(
            builder: (value) => CustData(
                  userModel: userModel,
                ));
        Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
      }
    } catch (e) {
      print('ERRORRR ===>>> ${e.toString()}');
    }
  }

//------------------------------------------------------------------------
  Future<void> check2MenuId() async {
    currentModel.uSERID = userID;
    //currentModel.fULLNAME = currentModel[index].fullName;
    MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => HoldingList(userModel: currentModel));
    Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
  }

  //เปลี่ยนสี กรณีติดลบใหเป็นสีลม
  Color getColor(double selector) {
    if (selector >= 0.001) {
      return Colors.green[300];
    } else {
      return Colors.redAccent;
    }
  }

  Widget showListData(int index) {
    double totalcost = resultModels[index].totalCost;
    double marketValue = resultModels[index].marketValue;
    double returnPC = resultModels[index].returnPC;
    double gainLoss = resultModels[index].gainLoss;
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 1.0, 5.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),

                child: new Text(
                  my2Format(totalcost, "totalcost ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 1.0, 5.0),
                child: new Text(
                  my2Format(marketValue, "marketValue ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 1.0, 5.0),
                child: new Text(
                  my2Format(gainLoss, "gainLoss ="),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: getColor(gainLoss),
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 1.0, 5.0),
                child: new Text(
                  myPercentFormat(returnPC, "returnPC = "),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: getColor(returnPC),
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                  //),
                ),
              ),
            ]),
      ],
    ));
  }

  Future<double> sumTotal(Stream<int> stream) async {
    var sum = 0.00;
    await for (var value in stream) {
      sum += value;
    }
    return sum;
  }

  Widget showListViewsumData() {
    return ListView.builder(
      itemCount: resultModels.length,
      itemBuilder: (BuildContext context, int index) {
        //return check2MenuId(index);
        return;
      },
    );
  }

// double totalcost = resultModels[index].totalCost;
//double marketValue = resultModels[index].marketValue;
//double returnPC = resultModels[index].returnPC;
// double gainLoss = resultModels[index].gainLoss;

  Widget showListDatah(int index) {
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                child: new Text(
                  resultModels[index].fundCode.trim(),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: MyStyle().deepPurple900,
                      decorationColor: MyStyle().c3),
                ),
              ),
            ]),
      ],
    ));
  }

  List<int> sort(List<int> _myBranchListName) {
    //List<int> resultModels[index].riskLevel;
    _myBranchListName.sort();
    print(_myBranchListName); // will show the result in the run log
    return _myBranchListName;
  }

  Widget showListData2h(int index) {
    var nlist = [resultModels[index].riskLevel];
    var ascending = nlist..sort();
    var descending = ascending.reversed;

    // print(ascending);
    print(descending);
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            child: new Text(
              resultModels[index].fGroupCode.trim(),
              textAlign: TextAlign.left,
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: MyStyle().greent1, decorationColor: MyStyle().blue600),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            child: new Text(
              'Risk Level :' + resultModels[index].riskLevel.toString(),
              textAlign: TextAlign.left,
              textScaleFactor: 0.8,
              style: TextStyle(
                  color: MyStyle().deepPurple900,
                  decorationColor: MyStyle().blue600),
            ),
          ),
        ]),
      ],
    ));
  }

  Widget showListGraint(int index) {
    double returnPC = resultModels[index].returnPC;
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
            child: new Text(
              my2Format(returnPC, "returnPC ="),
              textAlign: TextAlign.left,
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: MyStyle().blue900, decorationColor: MyStyle().c3),
            ),
          ),
        ]),
      ],
    ));
  }

  Widget showText2(int index) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      width: MediaQuery.of(context).size.width * 0.7 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showListDatah(index),
          showListData2h(index),
          showListData(index),
        ],
      ),
    );
  }

  Widget showListViewData() {
    return ListView.builder(
      itemCount: resultModels.length,
      itemBuilder: (BuildContext context, int index) {
        return showText2(index);
      },
    );
  }

  Widget showContent(int index) {
    return Card(
      child: Column(
        children: <Widget>[
          showListData(index),
        ],
      ),
    );
  }

  Future<void> exittoMain() async {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return Authen();
    });
    Navigator.of(context).push(materialPageRoute);
  }

  @override

  ///*
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: PreferredSize(
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(120.0, 0.30),
                  blurRadius: 20.0,
                )
              ]),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 80.0,
                title: showTitle2(),
                centerTitle: false,
                bottom: PreferredSize(
                    child: Text(
                      'Total Cost    Market Value      Unrealized G/L',
                      style: TextStyle(color: MyStyle().black1),
                      textScaleFactor: 1.1,
                    ),
                    preferredSize: Size.fromHeight(85)),
                actions: [
                  //leading: new IconButton(icon: Icon(Icons.arrow_back),
                  showCustomerName(),
                  //showTitle2(),
                  //showTitle(),
                  new IconButton(
                    icon: new Icon(Icons.menu),
                    onPressed: checkExittoMain,
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                        color: Colors.black,
                  ),
                ],
              ),
            ),
            //preferredSize: Size.fromHeight(kToolbarHeight),
            //ความกว้างของ Bar
            preferredSize: Size.fromHeight(85),
          ),
          body: resultModels.length == 0 ? showProcess() : showListViewData(),
          floatingActionButton: FloatingActionButton.extended(
            elevation: 4.0,
            icon: const Icon(Icons.add),
            label: const Text('Look Up'),
            onPressed: () {
              check2MenuId();
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: exittoMain,
                  tooltip: 'ไปหน้า Login หน้าแรก',
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: exittoMain,
                ),
              ],
            ),
            color: Colors.blueAccent[100],
          ),
        ));
  }
}
