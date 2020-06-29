import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/result_model.dart';
import '../models/user_model.dart';
import '../models/my_style.dart';
import '../models/result_total.dart';
import '../widget/agentlookup.dart';
import '../widget/holdinglist.dart';
import '../widget/authen.dart';
import '../models/result_cost.dart';
import '../models/result_gcode.dart';

class HoldingDatanew extends StatefulWidget {
  final UserModel userModel;
  HoldingDatanew({Key key, this.userModel}) : super(key: key);

  @override
  _HoldingDataState createState() => _HoldingDataState();
}

class _HoldingDataState extends State<HoldingDatanew>
    with SingleTickerProviderStateMixin {
  // Field

  List<Widget> myTab = <Widget>[
    Tab(
      text: "My InveesMent",
      icon: Icon(Icons.chat),
    ),
    Tab(text: "My Protfolio", icon: Icon(Icons.group)),
    Tab(text: "Historcal Return", icon: Icon(Icons.announcement))
  ];

  UserModel currentModel;
  String token, userID;
  String users, password;
  String userss;
  String customerName;
  Double totalaveragecost;
  Double totalMaketprice;
  List risklevels = [];
  Double total;
  Double totalcost;
  var sum = 0;
  double unTOTAL = 0;
  String gCode;
  String qqCodeold;

  List<ResultModel> resultModels = List();
  List<Resultcost> resultcosts = List();

  List<Resultt> resultts = List();

  List<double> tOTALs = List();

  List<Resultgroub> resultgroubs = List();

  TabController tabController;

  // Method
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
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
    readDataTotal();
    readDataCost();
  }

  Future<void> readData() async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/summary/$userID';
    // String url = 'http://115.31.144.227:3009/api/wr/summary/$userID';
    // String url = 'http://10.211.55.5:3009/api/wr/summary/$userID';

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
      // print('AvgCode ===>>> ${resultt.avgCost}');
      setState(() {
        resultModels.add(resultModel);
      });
      print('resultModels.lenght ===>>>  ${resultModels.length}');
    }
  }

  Future<void> readDataTotal() async {
    String url =
        'https://wr.wealthrepublic.co.th:3009/api/wr/summaryGroupByFundType/$userID';
    // String url ='http://115.31.144.227:3009/api/wr/summaryGroupByFundType/$userID';
    //String    url ='http://10.211.55.5:3009/api/wr/summaryGroupByFundType/$userID';

    Map<String, String> headers = Map();
    headers['Authorization'] = token;
    http.Response response = await http.get(url, headers: headers);
    var result = json.decode(response.body);
    print('result ===>>> $result');
    var myResult = json.decode(response.body)['result'];
    // print('myResult = $myResult');
    for (var map in myResult) {
      // print('map ===>> $map');
      Resultt resultt = Resultt.fromJson(map);
      // print('AvgCode ===>>> ${resultModel.avgCost}');
      setState(() {
        resultts.add(resultt);
        unTOTAL = unTOTAL + resultt.tOTALCOST;
      });
      print('resultt.lenght ===>>>  ${resultts.length}');
    }
  }

  Future<void> readDataCost() async {
    String url =
        'https://wr.wealthrepublic.co.th:3009/api/wr/summarycost/$userID';
    // String url = 'http://115.31.144.227:3009/api/wr/summarycost/$userID';
    // String url ='http://10.211.55.5:3009/api/wr/summarycost/$userID';

    Map<String, String> headers = Map();
    headers['Authorization'] = token;
    http.Response response = await http.get(url, headers: headers);
    var result = json.decode(response.body);
    print('result ===>>> $result');
    var myResult = json.decode(response.body)['result'];
    // print('myResult = $myResult');
    for (var map in myResult) {
      // print('map ===>> $map');
      Resultcost resultcost = Resultcost.fromJson(map);
      // print('AvgCode ===>>> ${resultModel.avgCost}');
      setState(() {
        resultcosts.add(resultcost);
      });
      print('resultcost.lenght ===>>>  ${resultcosts.length}');
    }
  }

  Future<void> readDataGroup(String qcode) async {
    if (resultgroubs.length != 0) {
      resultgroubs.clear();
    }

    String url =
        'https://wr.wealthrepublic.co.th:3009/api/wr/groupcodes/$userID?gCode=$qcode';
    // String url = 'http://115.31.144.227:3009/api/wr/groupcodes/$userID?gCode=$qcode';

    // String url = 'http://10.211.55.5:3009/api/wr/groupcodes/$userID?gCode=$qcode';

    Map<String, String> headers = Map();
    headers['Authorization'] = token;
    headers['Params'] = gCode;
    http.Response response = await http.get(url, headers: headers);
    var result = json.decode(response.body);

    print('UserId ===>>> $result');
    var myResult = json.decode(response.body)['result'];
    // print('myResult = $myResult');
    for (var map in myResult) {
      // print('map ===>> $map');
      Resultgroub resultgroub = Resultgroub.fromJson(map);
      print('AvgCode ===>>> ${resultgroub.avgCost}');
      setState(() {
        resultgroubs.add(resultgroub);
      });
      print('resultgroubs.lenght ===>>>  ${resultgroubs.length}');
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

  Widget convertThai(String status) {
    if (status == "Alternative") {
      return Text(
        'กองทุนรวมที่ลงทุนในสินทรัพย์ทางเลือก',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFC9C2D3),
        ),
      );
    } else if (status == "LTF") {
      return Text(
        'กองทุนรวมตราสารทุน',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFF3EFF2),
        ),
      );
    } else if (status == "FI") {
      return Text(
        'กองทุนเงินตราสารหนี้',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE2EAEE),
        ),
      );
    } else if (status == "MMF") {
      return Text(
        'กองทุนรวมตลาดเงินที่ลงทุนในประเทศ',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE9EFF1),
        ),
      );
    } else if (status == "RMF") {
      return Text(
        'กองทุนรวมเพื่อการเลี้ยงชีพ',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE2E9EC),
        ),
      );
    } else if (status == "FIF-EQ") {
      return Text(
        'กองทุนรวมตราสารทุน',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFDCE4E7),
        ),
      );
    } else if (status == "FIF-PF&REIT") {
      return Text(
        'กองทุนรวมหมวดอุตสาหกรรม',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE4EBEE),
        ),
      );
    } else if (status == "EQ") {
      return Text(
        'ลงทุนในตราสารทุน หรือ หุ้นต่างประเทศ',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else if (status == "MIX") {
      return Text(
        'กองทุนรวมผสม',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else if (status == "SSF") {
      return Text(
        'SUPER SAVINGS FUND',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else if (status == "SSFX") {
      return Text(
        'SUPER SAVINGS FUND EXTRA',
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else {
      return Text(
        "Waiting",
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFFE6EDF0),
        ),
      );
    }
  }

  Color getColorbar(String fund) {
    if (fund == "Alternative") {
      return Color(0xFF0C0A0A);
    } else if (fund == "LTF") {
      return Color(0xFF0C0A0A);
    } else if (fund == "FI") {
      return Color(0xFF0C0A0A);
    } else if (fund == "MMF") {
      return Color(0xFF0C0A0A);
    } else if (fund == "RrMF") {
      return Color(0xFF0C0A0A);
    } else if (fund == "FIF-EQ") {
      return Color(0xFF0C0A0A);
    } else if (fund == "EQ") {
      return Color(0xFF0C0A0A);
    } else if (fund == "FIF-PF&REIT") {
      return Color(0xFF0C0A0A);
    } else if (fund == "MIX") {
      return Color(0xFF0C0A0A);
    } else {
      return Color(0xFF0C0A0A);
    }
  }

  //กองทุนรวมที่นำเงินไปลงทุนในตราสารทุน

  String myFormatint(int myDoubleint, String title) {
    NumberFormat numberFormat = NumberFormat('#');
    return numberFormat.format(myDoubleint);
  }

  String myFormat(double myDouble, String title) {
    NumberFormat numberFormat = NumberFormat('#,##0.0000');
    return numberFormat.format(myDouble);
  }

  String my2Format(double myDouble, String title) {
    print('myDouble ==> $myDouble');
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
          style: GoogleFonts.sarabun(
            fontSize: 16.0,
            color: Colors.lightGreenAccent[50],
          ),
        ),
      ],
    );
  }

  Widget showTitle2() {
    EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 1.0);
    return Column(
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

//------------------------------------------------------------------------
  Future<void> check2MenuId() async {
    currentModel.uSERID = userID;
    MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => HoldingList(userModel: currentModel));
    Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
  }

  //Change Color Under Cost
  Color getColor(double selector) {
    if (selector >= 0.001) {
      return Color(0xFF12A70D);
    } else {
      return Color(0xFFD50000);
    }
  }

  Widget showListDataGroup(int index) {
    double tOTALCOST = resultts[index].tOTALCOST;
    double uNGL = resultts[index].uNGL;
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 1.0, 15.0),
                child: new Text(
                  my2Format(tOTALCOST, "tOTALCOST ="),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontSize: 16.0,
                    color: getColor(tOTALCOST),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                child: new Text(
                  my2Format(uNGL, "uNGL ="),
                  //softWrap: true,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontSize: 16.0,
                    color: getColor(uNGL),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showAllfund(int index) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      width: MediaQuery.of(context).size.width * 0.7 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showListFund(index),
          showListsubFund(index),
          showListsubFund2(index),
        ],
      ),
    );
  }

  Widget showListDataFund() {
    return ListView.builder(
      itemCount: resultts.length,
      itemBuilder: (BuildContext context, int index) {
        return showAllfund(index);
      },
    );
  }

//---------------------------------------------23-04-2563
  List<int> myIndexs = List();
  Widget showListFund(int index) {
    myIndexs.add(index);
    double tOTALCOST = resultts[index].tOTALCOST;
    String gCode = resultts[index].fUNDTYPE.trim();

    tOTALs.add(tOTALCOST); //บวกยอดเข้าไป

    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(1.0, 3.0, 0.0, 3.0),
              color: getColorbar(gCode),
              width: MediaQuery.of(context).size.width * 0.95 - 4.0,
              child: convertThai(
                resultts[index].fUNDTYPE,
              ),
            ),
          ],
        ),
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Expanded(
                child: new Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        resultts[index].fUNDTYPE,
                        style: GoogleFonts.sarabun(
                          fontSize: 16.0,
                          color: Color(0xFFDDDDE6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      showDropdown(tOTALCOST, gCode),
                    ],
                  ),
                ]),
                flex: 1,
              ),
            ]),
      ],
    ));
  }

  //My Investment Page#1 pupup
  DropdownButton<String> showDropdown(double tOTALCOST, String gCode) {
    List<String> showTexts = List();
    //showTexts.add("Return");
    showTexts.add(gCode.trim());
    String choseItem;

    return DropdownButton(
        isExpanded: false,
        iconSize: 50.0,
        autofocus: false,
        value: choseItem,
        items: showTexts.map((value) {
          return DropdownMenuItem(
            child: Text(value),
            value: value,
          );
        }).toList(),
        hint: new Text(
          my2Format(tOTALCOST, 'tOTALCOST'),
          style: GoogleFonts.sarabun(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: Color(0xFFDDDDE6),
          ),
        ),
        onChanged: (gCode) {
          print('value ==>> $gCode');

          //Chang Tab 2
          setState((){changeTabController();});
          showPage2sumDatab(gCode); //Call Data
          
        });
  }

  void changeTabController() {
    tabController.index = 1; //มีปัญหาตรงจุดนี้แหละ
  }

  Future<void> showListDataDialog(String qcode, int index) async {
    readDataGroup(qcode);

    showDialog(
      context: context,
      builder: (value) => AlertDialog(
        title: Text(resultgroubs[index].fGroupCode.trim()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showListDataGroub(index),
            showListDataGroubsub3(index),
            showListDataGroubsub2(index),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('OK'))
        ],
      ),
    );
  }

//-------------Page Myinvestment Page #1
  Widget showListsubFund(int index) {
    double uNGL = resultts[index].uNGL;

    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,end
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 10.0, 0.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                child: new Text(
                  "กำไร (บาท)",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Color(0xFFDDDDE6),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 10.0, 0.0),
                child: new Text(
                  my2Format(uNGL, "uNGL ="),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: getColor(uNGL),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showListsubFund2(int index) {
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,end
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 10.0, 0.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                child: new Text(
                  "",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 12.0,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showListData(int index) {
    double totalcost = resultModels[index].totalCost;
    double marketValue = resultModels[index].marketValue;
    double returnPC = resultModels[index].returnPC;
    double gainLoss = resultModels[index].gainLoss;
    String funType = resultModels[index].fGroupCode;
    print('funType ==>>> $funType');
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.w200,
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),
                  //),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showProcessx() {
    return Center(
      child: CircularProgressIndicator(),
      heightFactor: 40.0,
      widthFactor: 40.0,
    );
  }

  Widget showListViewsumData2b() {
    return resultgroubs.length == 0
        ? showProcessx()
        : ListView.builder(
            itemCount: resultgroubs.length,
            itemBuilder: (BuildContext context, int index) {
              return showAllholding(index);
            },
          );
  }

//show Page #2 All Display
  Widget showAllholding(int indexx) {

    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      width: MediaQuery.of(context).size.width * 0.7 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showListData3(indexx),
          showListHead1(indexx),
          showListData1(indexx),
          showListHead2(indexx),
          showListData2(indexx),
        ],
      ),
    );
  }

//-----------------------------------------------28-04-2020
  Widget showPage2sumDatab(String qcodex) {
    setState(() { });
      //changeTabController();
      readDataGroup(qcodex);
      
      print('กลุ่มที่ต้องการแสดง ==>>> $qcodex');
   

    return resultgroubs.length == 0
        ? showProcessx()
        : ListView.builder(
            itemCount: resultgroubs.length,
            itemBuilder: (BuildContext context, int index1) {
              return showAllholding(index1);
            },
          );
  }

  //รายละเอียดของกองทุน  หน้าที่ 2
  Widget showListDataGroub(int index) {
    double totalcost = 0.00;
    double marketValue = 0.00;
    String funType = "";

    totalcost = resultgroubs[index].totalCost;
    marketValue = resultgroubs[index].marketValue;

    funType = resultgroubs[index].fundNameT;

    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 1.0, 5.0),
              color: Color(0xFF070707),
              width: MediaQuery.of(context).size.width * 0.94 - 10.0,
              child: Text(
                funType,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: Color(0xFFEAE9F3),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 1.0, 5.0),
              color: Color(0xFF070707),
              width: MediaQuery.of(context).size.width * 0.94 - 10.0,
              child: Text(
                "Total Net assets:",
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.0,
                  color: Color(0xFFEAE9F3),
                ),
              ),
            ),
          ],
        ),
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                child: new Text(
                  my2Format(totalcost, "totalcost ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
              new Padding(
                //padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                padding: EdgeInsets.only(left: 0.0, right: 120.0),
                child: new Text(
                  "",
                  softWrap: true,
                  textAlign: TextAlign.left,
                  //alignment: Alignment(0.10, -10.0),
                  style: GoogleFonts.sarabun(
                    color: Color(0xFFE4E4EB),
                    fontWeight: FontWeight.w300,
                    fontSize: 8.0,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  my2Format(marketValue, "marketValue ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  //รายละเอียดรายการของกองทุน
  Widget showListHead1(int index) {
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                child: new Text(
                  "NAV",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
              new Padding(
                //padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                padding: EdgeInsets.only(left: 75.0, right: 0.0),
                child: new Text(
                  "Market Value",
                  softWrap: true,
                  textAlign: TextAlign.left,
                  //alignment: Alignment(0.10, -10.0),
                  style: GoogleFonts.sarabun(
                    color: Color(0xFFE4E4EB),
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                child: new Text(
                  "Unrealized",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  //รายละเอียดรายการของกองทุน
  Widget showListHead2(int index) {
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                child: new Text(
                  "Avg Cost",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
              new Padding(
                //padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                padding: EdgeInsets.only(left: 60, right: 8, bottom: 8),
                //padding: EdgeInsets.only(left: 60.0, right: 0.0),
                child: new Text(
                  "Cost",
                  softWrap: true,
                  textAlign: TextAlign.left,
                  //alignment: Alignment(0.10, -10.0),
                  style: GoogleFonts.sarabun(
                    color: Color(0xFFE4E4EB),
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                child: new Text(
                  "Unit",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  //รายละเอียดรายการของกองทุน
  Widget showListData2(int index) {
    double totalcost = 0.00;
    double units = 0.0000;
    double avgcosts = 0.0000;

    totalcost = resultgroubs[index].totalCost;
    units = resultgroubs[index].balanceUnit;
    avgcosts = resultgroubs[index].avgCostUnit;

    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                child: new Text(
                  myFormat(avgcosts, "avgcosts ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
              new Padding(
                //padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                padding: EdgeInsets.only(left: 60, right: 8, bottom: 0),
                //padding: EdgeInsets.only(left: 60.0, right: 5.0),
                child: new Text(
                  my2Format(totalcost, "totalcost ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  //alignment: Alignment(0.10, -10.0),
                  style: GoogleFonts.sarabun(
                      color: Color(0xFFE4E4EB),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      height: 1.0,
                      letterSpacing: 1.0),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                child: new Text(
                  myFormat(units, "units ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  //รายละเอียดรายการของกองทุน
  Widget showListData1(int index) {
    double currents = 0.00;
    double urealized = 0.0000;
    double navs = 0.0000;
    currents = resultgroubs[index].marketValue;
    urealized = resultgroubs[index].gainLoss;
    navs = resultgroubs[index].marketPrice;
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                //padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                child: new Text(
                  myFormat(navs, "navs ="),
                  softWrap: true,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Color(0xFFEAE9F3),
                  ),
                ),
              ),
              new Padding(
                //padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                //padding: EdgeInsets.only(left: 50.0, right: 5.0),
                padding: EdgeInsets.only(left: 50, right: 8, bottom: 0),
                child: new Text(
                  my2Format(currents, "currents ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                      color: Color(0xFFE4E4EB),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      height: 1.0,
                      letterSpacing: 1.0),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                child: new Text(
                  my2Format(urealized, "urealized ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: getColor(urealized),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showListData3(int index) {
    double gainLoss = 0.00;
    String funType = "";
    String dataDate = resultgroubs[index].dataDate;
    DateTime todayDate = DateTime.parse(dataDate);
    String formdate = formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
    gainLoss = resultgroubs[index].returnPC;
    funType = resultgroubs[index].fundNameT;
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 1.0, 5.0),
              //color: Color(0xFF09090F),

              width: MediaQuery.of(context).size.width * 0.94 - 10.0,
              child: Text(
                funType,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: Color(0xFFE9E9F0),
                ),
              ),
            ),
          ],
        ),
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  "@ " + formdate,
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                    //color: getColor(gainLoss),
                    color: Color(0xFFE9E9F0),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  my2Format(gainLoss, "gainLoss =").toString() + "%",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    color: getColor(gainLoss),
                    //color: Color(0xFFE9E9F0),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  //Page #2

  Widget showListDataGroubsub2(int index) {
    double returnPC = 0.00;

    returnPC = resultgroubs[index].returnPC;
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  " ",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 12.0,
                    color: getColor(returnPC),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  myPercentFormat(returnPC, "returnPC ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: getColor(returnPC),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showListDataGroubsub3(int index) {
    double gainLoss = 0.00;
    String funtypes = "";
    gainLoss = resultgroubs[index].gainLoss;
    funtypes = resultgroubs[index].fundNameT;
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  funtypes,
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: getColor(gainLoss),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  my2Format(gainLoss, "gainLoss ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: getColor(gainLoss),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showListViewsumData() {
    return ListView.builder(
      itemCount: resultts.length,
      itemBuilder: (BuildContext context, int index) {
        return showListDataGroup(index);
      },
    );
  }

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
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Color(0xFFDDDDE6),
                  ),
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

  double getSum(double selector) {
    var sum;
    if (selector >= 0.001) {
      return sum += selector;
    } else {
      return selector;
    }
  }

  Widget showSum2Data() {
    return ListView.builder(
      itemCount: resultModels.length,
      itemBuilder: (BuildContext context, int index) {
        return;
      },
    );
  }

//-----------------------------------------------แสดงยอดงเงินลงทุน

  Widget showSumDatacost() {
    return ListView.builder(
      itemCount: resultcosts.length,
      itemBuilder: (BuildContext context, int index) {
        return showAllsum(0);
      },
    );
  }
//----------------------------------------------------Fund

  Widget showFundSumDatacost() {
    return ListView.builder(
      itemCount: resultts.length,
      itemBuilder: (BuildContext context, int index) {
        return showListFund(index);
      },
    );
  }

  Widget showAllsum(int index) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      width: MediaQuery.of(context).size.width * 0.7 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showDispDate(0),
          showListViewSumData(0),
        ],
      ),
    );
  }

  //head Report show Page#1
  Widget showDispDate(int index) {
    String dataDate = resultcosts[index].dataDate;
    DateTime todayDate = DateTime.parse(dataDate);
    String formdate = formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 5.0),
            child: new Text(
              "มูลค่าการลงทุน(บาท)/Market Value ณ",
              textAlign: TextAlign.left,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                color: Color(0xFFDCDCE7),
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 5.0, 1.0),
            child: new Text(
              formdate,
              textAlign: TextAlign.left,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: Color(0xFFDCDCE7),
              ),
            ),
          ),
        ]),
      ],
    ));
  }

//รวมยอดการลงทุน Header Page#1
  Widget showListViewSumData(int index) {
    double totalsum = resultcosts[index].marketValue;
    double gainLoss = resultcosts[index].gainLoss;
    //var sum = sumTotal2(totalcost);
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 15.0),
                child: new Text(
                  my2Format(totalsum, "totalsum ="),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.2,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Color(0xFFDCDCE7),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 15.0),
                child: new Text(
                  my2Format(gainLoss, "gainLoss ="),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.0,
                  style: GoogleFonts.sarabun(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: getColor(gainLoss),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  Widget showSumData() {
    return ListView.builder(
      itemCount: resultModels.length,
      itemBuilder: (BuildContext context, int index) {
        return showInvest2(index);
      },
    );
  }

  Widget showInvest2(int index) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      width: MediaQuery.of(context).size.width * 0.7 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showMyinVestMent(index),
        ],
      ),
    );
  }

  Widget showMyinVestMent(int index) {
    double totalcost = resultModels[index].totalCost;
    //var sum = sumTotal2(totalcost);
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
                  "ยอดเงินการลงทุน",
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: MyStyle().deepPurple900,
                      decorationColor: MyStyle().c3),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                child: new Text(
                  totalcost.toString(),
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
                  color: Color(0xFF595970), decorationColor: MyStyle().blue600),
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
      width: MediaQuery.of(context).size.width * 0.90 - 10,
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

  //DefaultTabController

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Color(0xFF0C0C0C),
          appBar: AppBar(
            title: Text(
              "พอร์ตการลงทุน",
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.w600,
                fontSize: 26.0,
                color: Color(0xFFE9E9F1),
              ),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.account_balance_wallet),
                  onPressed: check2MenuId,
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            backgroundColor: Color(0xFF0C0C0C),

            //Changing this will change the color of  the TabBar

            titleSpacing: 20.0,
            centerTitle: false,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.home), onPressed: checkExitto2Main),
            ],
            bottom: TabBar(
              controller: tabController,
              indicatorColor: Color(0xFF910D7B),
              labelColor: Color(0xFFEAEAF3),

              labelStyle:
                  TextStyle(fontWeight: FontWeight.w300, fontSize: 10.0),
              //
              labelPadding: null,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: myTab,
            ),
          ),
          drawer: Container(
            width: 100,
            // height: 5,
            color: Color(0xFF0C0C0C),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              myInvessment(),
              showListViewsumData2b(),
              showListViewsumData(),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new IconButton(
                  icon: Icon(Icons.assignment),
                  tooltip: 'รายการซื้อ',
                  iconSize: 20.0,
                  color: Colors.white,
                  onPressed: () {},
                ),
                new IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                  ),
                  tooltip: 'Delete Data',
                  iconSize: 20.0,
                  color: Colors.white,
                  onPressed: () {
                    for (int i = 0; i < 10; i++) {
                      setState(() {
                        resultgroubs.removeAt(0);
                      });
                    }
                  },
                ),
              ],
            ),
            color: Color(0xFF0C0C0C),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  SafeArea myInvessment() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Container(
            child: resultModels.length == 0 ? showProcess() : showSumDatacost(),
            height: 100,
            color: Color(0xFF0C0C0C),
          ),
          Container(
            child:
                resultModels.length == 0 ? showProcess() : showListDataFund(),
            height: 360,
            color: Color(0xFF0C0C0C),
          ),

          //showTotal(), //รวมยอดทั้งหมด
        ],
      ),
    );
  }

  Widget showTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text('Total = ${my2Format(unTOTAL, 'unTOTAL=')}'),
      ],
    );
  }
}
