import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
 
import '../models/result_model.dart';
import '../models/user_model.dart';
import '../models/my_style.dart';
import '../widget/authen.dart';
import '../widget/agentlookup.dart';
 

class ReadData extends StatefulWidget {
  final UserModel userModel;
  //ReadData({Key key, this.userModel}) : super(key: key);
  ReadData({Key key, this.userModel}) : super(key: key);
  @override
  _ReadDataState createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  // Field
  UserModel currentModel;
  String token, userID;
  String user,password;
  List<ResultModel> resultModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    currentModel = widget.userModel;
    token = currentModel.token;
    token = 'Bearer $token';
    userID = currentModel.uSERID;
    user =currentModel.loginName;
    password = "123456";
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

  Widget showContent(int index) {
    return Card(
      child: Column(
        children: <Widget>[
          showAmcName(index),
          showFundGName(index),
          showFundName(index),
          showFundGroub(index),
          showLevels(index),
          showBaanceUnit(index),
          showAveratecostUnit(index),
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

  Widget showBaanceUnit(int index) {
    double balanceUnit = resultModels[index].balanceUnit;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
        child: Text('จำนวนหน่วย/Unit Holding :', textAlign: TextAlign.left),),
        Text(
          myFormat(balanceUnit, 'BalanceUnit ='),
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
      child: Text('มูลค่าต่อหน่วย/NAV-Unit :', textAlign: TextAlign.left),),
      Text(
        myFormat(marketPrice, 'MarketPrice ='),
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
        child: Text('ระดับความเสี่ยง/Risk Level :', textAlign: TextAlign.left),),
        Text(
          myFormatint(riskLevel, 'riskLevel ='),
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
       child: Text('ต้นทุนเฉลี่ยต่อหน่วย/Average Cost PerUnit :', textAlign: TextAlign.left),),
      Text(
        myFormat(avgCostUnit, "AvgCostUnit ="),
      ),
    ],
  );
}

Widget showMaketValue(int index) {
  double marketValue = resultModels[index].marketValue;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
       Expanded(
       child: Text('มูลค่าทางกาารตลาด/Cost Maket Value :', textAlign: TextAlign.left),),
      Text(
        my2Format(marketValue, "MarketValue ="),
      ),
    ],
  );
}

Widget showTotalValue(int index) {
  double totalcost = resultModels[index].totalCost;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
       Expanded(
       child: Text('มูลค่าเงินลงทุน/Total Cost  :', textAlign: TextAlign.left),),
      Text(my2Format(totalcost, "totalCost ="),),
    ],
  );
}

Widget showgainLoss(int index) {
  double gainLoss = resultModels[index].gainLoss;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
       Expanded(
       child: Text('กำไร(ขาดทุน)ที่ยังไม่รับรู้ Gain(Loss) :', textAlign: TextAlign.left),),
      Text(my2Format(gainLoss, "GainLoss ="),),
    ],
  );
}

Widget showReturnPC(int index) {
  double returnPC = resultModels[index].returnPC;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
       Expanded(
       child: Text('กำไร(ขาดทุน)ที่ยังไม่รับรู้/Unrealized Grain (Loss) :', textAlign: TextAlign.left),),
      Text(my2Format(returnPC, "ReturnPC ="),),
    ],
  );
}

Widget showProportion(int index) {
  double proportion = resultModels[index].proportion;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
       Expanded(
       child: Text('สัดส่วน/Proportion :', textAlign: TextAlign.left),),
      Text(my2Format(proportion, "Proportion ="),),
      Text('%'),
    ],
  );
}




String myFormatint(int myDoubleint, String title) {
  NumberFormat numberFormat = NumberFormat('#');
  return numberFormat.format(myDoubleint);
}


  String myFormat(double myDouble, String title) {
    NumberFormat numberFormat = NumberFormat('#,###0.0000');
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
  new DateFormat();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MMM-dd');
  String formatted = formatter.format(now);

  return formatted;
}


Widget showDateAs(int index) {
  String dataDate = resultModels[index].dataDate;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
       Expanded(
       child: Text('Nav Date/ณ วันที่', textAlign: TextAlign.left),),
      Text(
        myFormatdate("DataDate",dataDate), 
      ),
    ],
  );
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
      'Holding Report',
      style: TextStyle(
        fontFamily: 'Raleway', //Raleway
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: MyStyle().deepPurple900,
      ),
    );
    //Text(showDate());
  }

Future<void> webExittoMain() async  {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return Authen();
          });
              Navigator.of(context).push(materialPageRoute);
}

Future<void> checkExittoMain() async {
String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
//String url = 'http://115.31.144.227:3009/api/user/login';
//String url = 'http://10.211.55.4:3009/api/user/login';
try {
  // // Dio Type
  Map<String, dynamic> map = Map();
  map['email'] = user;
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
            userModel: userModel, ));
            Navigator.of(context).pushAndRemoveUntil(route, (value)=>false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: resultModels.length == 0 ? showProcess() : showListView(),
      appBar: AppBar(
        backgroundColor: MyStyle().barColor,
        title: showTitle(),
        //title: showDateAs(1),
        actions: <Widget>[
    IconButton(
      icon: Icon(
        Icons.exit_to_app,
        color: Colors.white,
      ),
      onPressed: checkExittoMain, //() {},
    )
  ],),);
  }
}

