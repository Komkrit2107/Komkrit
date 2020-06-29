import 'dart:convert';
import 'dart:ffi';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import '../models/result_model.dart';
import '../models/user_model.dart';
import '../models/my_style.dart';
import '../widget/agentlookup.dart';
import '../widget/authen.dart';

class HoldingList extends StatefulWidget {
  final UserModel userModel;
  HoldingList({Key key, this.userModel}) : super(key: key);

  @override
  _HoldingListState createState() => _HoldingListState();
}

class _HoldingListState extends State<HoldingList> {
  // Field
  UserModel currentModel;
  String token, userID;
  String users, password;
  String userss;
  String customerName;
  Double totalaveragecost;
  Double totalMaketprice;

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
    //String url = 'http://10.211.55.5:3009/api/wr/summary/$userID';

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

Future<void> checkExitto2Main() async {
  String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
  // String url = 'http://115.31.144.227:3009/api/user/login';
  //  String url = 'http://10.211.55.5:3009/api/user/login';
  try {
    // // Dio Type
    // Map<String, dynamic> map = Map();
    // map['email'] = userss;
    // map['password'] = password;
    // print('map ==>> ${map.toString()}');
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/json';
    print('headers ==>> $headers');
    String bodyMap = '{"email":"$userss","password":"$password"}';
    var response = await http.post(url, headers: headers, body: bodyMap);
    print('statusCode = ${response.statusCode}');
    if (response.statusCode == 401) {
      print('Login False');
    } else {
      var result = json.decode(response.body);
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


  Widget showProcess() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showContent(int index) {
    return Card(
      child: Column(
        children: <Widget>[
          //showListall(index),
          showAmcName(index),
          showFundGName(index),
          showFundName(index),
          showFundGroub(index),
          showLevels(index),
          showBaanceUnit(index),
          showAveratecostUnit(index),
          showDateAs(index),
          showNav(index),
          showTotalValue(index),
          showMaketValue(index),
          showgainLoss(index),
          showProportion(index),
          //showReturnPC(index),
          //showLevels(index),
          //Text(resultModels[index].totalCost.toString()),
          //showBaanceUnit(index),
          //Text(resultModels[index].avgCost.toString()),
          //showAveratecost(index),
        ],
      ),
    );
  }

  //เปลี่ยนสี กรณีติดลบใหเป็นสีลม
  Color getColor(double selector) {
    if (selector >= 0.001) {
      return Colors.green[300];
    } else {
      return Colors.redAccent;
    }
  }

  Widget showListall(int index) {
    //double balanceUnit = resultModels[index].balanceUnit;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Text.rich(
          TextSpan(
            text: 'Hello', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: ' beautiful ',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  Widget showBaanceUnit(int index) {
    double balanceUnit = resultModels[index].balanceUnit;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'จำนวนหน่วย/Unit Holding :',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          myFormat(balanceUnit, 'BalanceUnit ='),
          style: TextStyle(fontSize: 10.0, color: MyStyle().yellow1),
        ),
      ],
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
            'มูลค่าต่อหน่วย/NAV-Unit :',
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

  Widget showLevels(int index) {
    int riskLevel = resultModels[index].riskLevel;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'ระดับความเสี่ยง/Risk Level :',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          myFormatint(riskLevel, 'riskLevel ='),
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }

  Widget showAveratecost(int index) {
    double avgCost = resultModels[index].marketPrice;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          myFormat(avgCost, 'AvgCost ='),
        ),
      ],
    );
  }

  Widget showAveratecostUnit(int index) {
    double avgCostUnit = resultModels[index].avgCostUnit;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'ต้นทุนเฉลี่ยต่อหน่วย/Average Cost PerUnit :',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          myFormat(avgCostUnit, "AvgCostUnit ="),
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }

  Widget showMaketValue(int index) {
    double marketValue = resultModels[index].marketValue;
    //totalMaketprice =+ resultModels[index].marketValue;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'มูลค่าทางกาารตลาด/Cost Maket Value :',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          my2Format(marketValue, "MarketValue ="),
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }

  Widget showTotalValue(int index) {
    double totalcost = resultModels[index].totalCost;
    //double totalall =  totalall + resultModels[index].totalCost;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'มูลค่าเงินลงทุน/Total Cost  :',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          my2Format(totalcost, "totalCost ="),
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }

  Widget showgainLoss(int index) {
    double gainLoss = resultModels[index].gainLoss;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'กำไร(ขาดทุน)ที่ยังไม่รับรู้ Gain(Loss) :',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          my2Format(gainLoss, "GainLoss ="),
          style: TextStyle(color: getColor(gainLoss), fontSize: 10.0),
        ),
      ],
    );
  }

  Widget showReturnPC(int index) {
    double returnPC = resultModels[index].returnPC;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            'กำไร(ขาดทุน)ที่ยังไม่รับรู้/Unrealized Grain (Loss) :',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        Text(
          my2Format(returnPC, "ReturnPC ="),
          style: TextStyle(color: getColor(returnPC), fontSize: 10.0),
        ),
      ],
    );
  }

  Widget showProportion(int index) {
    double returnPC = resultModels[index].returnPC;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            ' ',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: MyStyle().red1),
          ),
        ),
        Text(
          my2Format(returnPC, "returnPC ="),
          style: TextStyle(color: getColor(returnPC), fontSize: 10.0),
        ),
        Text('%'),
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
    // return '$title ${myDouble.toStringAsFixed(myDouble.truncateToDouble() == myDouble ? 0 : 2)}';
  }

  String my2Format(double myDouble, String title) {
    NumberFormat numberFormat = NumberFormat('#,##0.00');
    return numberFormat.format(myDouble);
    // return '$title ${myDouble.toStringAsFixed(myDouble.truncateToDouble() == myDouble ? 0 : 2)}';
  }

// Convert String date to Date
  String myFormatdate(String myDate, String title) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MMM-yyyy');
    String formatted = formatter.format(now);
    return formatted;
  }

  Widget showDateAs(int index) {
    String dataDate = resultModels[index].dataDate;
    DateTime todayDate = DateTime.parse(dataDate);
    String formdate = formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
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
        Text(formdate,
          
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

  Widget showTitle() {
    return Text(
      'Holding',
      style: TextStyle(
        fontFamily: 'Raleway', //Raleway
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: MyStyle().colorWhite,
      ),
    );
    //Text(showDate());
  }

  Widget showCustomerName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$customerName',
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 14.0,
            color: MyStyle().colorWhite,
          ),
        ),
      ],
    );
  }

  Future<void> checkExittoMain() async {
   // String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
// String url = 'http://115.31.144.227:3009/api/user/login';
   String url = 'http://10.211.55.5:3009/api/user/login';

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

  



  Widget showListView() {
    return ListView.builder(
      itemCount: resultModels.length,
      itemBuilder: (BuildContext context, int index) {
        return showContent(index);
      },
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: showTitle(),
        actions: <Widget>[
          showCustomerName(),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 20.0,
            ),
            onPressed: () {checkExitto2Main();},
          ),

          // mainAxisSize: MainAxisSize.max,
          // alignment: MainAxisAlignment.center,
        ],
      ),
      // body: Center( child: _widgetOptions.elementAt(_selectedIndex), ),
      body: resultModels.length == 0 ? showProcess() : showListView(),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: exittoMain,
              tooltip: 'Back to menu',
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: exittoMain,
              tooltip: 'ดูรายละเอียดที่อยู่ลูกค้า',
            ),
          ],
        ),
        color: Colors.cyan[600],
      ),
    );
  }
}
