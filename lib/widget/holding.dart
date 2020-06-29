import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
//import 'string_apis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:intl/number_symbols_data.dart';
import 'package:kritproduct/models/result_model.dart';
import 'package:kritproduct/models/user_model.dart';
import 'package:kritproduct/models/my_style.dart';
import 'package:kritproduct/models/result_total.dart';
import 'package:kritproduct/widget/agentlookup.dart';
import 'package:date_format/date_format.dart';
import 'package:kritproduct/widget/holdinglist.dart';
import 'package:kritproduct/widget/authen.dart';
import 'package:flutter/services.dart';
import 'package:kritproduct/models/result_cost.dart';
import 'package:kritproduct/models/result_gcode.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/my_style.dart';

class HoldingData extends StatefulWidget {
  final UserModel userModel;
  HoldingData({Key key, this.userModel}) : super(key: key);

  @override
  _HoldingDataState createState() => _HoldingDataState();
}

class _HoldingDataState extends State<HoldingData>
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
  List<Resultt> resultts = List();
  List<Resultcost> resultcosts = List();
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

    //readDataGroup();
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
    String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/summaryGroupByFundType/$userID';
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
    String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/summarycost/$userID';
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

  Future<void> deleteDataGroup(String qcode) async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/groupcodes/$userID?gCode=$qcode';
    // String url = 'http://115.31.144.227:3009/api/wr/groupcodes/$userID?gCode=$qcode';
    // String url = 'http://10.211.55.5:3009/api/wr/groupcodes/$userID?gCode=$qcode';

    Map<String, String> headers = Map();
    headers['Authorization'] = token;
    headers['Params'] = gCode;
    http.Response response = await http.delete(url, headers: headers);
    return response;
  }

  Future<void> readDataGroup(String qcode) async {
    if (resultgroubs.length != 0) {
      resultgroubs.clear();
    }

    String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/groupcodes/$userID?gCode=$qcode';
    // String url = 'http://115.31.144.227:3009/api/wr/groupcodes/$userID?gCode=$qcode';

    // String url = 'http://10.211.55.5:3009/api/wr/groupcodes/$userID?gCode=$qcode';

    Map<String, String> headers = Map();
    headers['Authorization'] = token;
    headers['Params'] = gCode;
    http.Response response = await http.get(url, headers: headers);
    var result = json.decode(response.body);
    print('result ===>>> $result');
    var myResult = json.decode(response.body)['result'];
    // print('myResult = $myResult');
    for (var map in myResult) {
      // print('map ===>> $map');
      Resultgroub resultgroub = Resultgroub.fromJson(map);
      print('AvgCode ===>>> ${resultgroub.avgCost}');
      setState(() {
        resultgroubs.add(resultgroub);
      });
      //print('resultgroubs.lenght ===>>>  ${resultgroubs.length}');
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
          fontSize: 16.0,
          color: Color(0xFFC9C2D3),
        ),
      );
    } else if (status == "LTF") {
      return Text(
        'กองทุนรวมตราสารทุน',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFF3EFF2),
        ),
      );
    } else if (status == "FI") {
      return Text(
        'กองทุนเงินตราสารหนี้',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE2EAEE),
        ),
      );
    } else if (status == "MMF") {
      return Text(
        'กองทุนรวมตลาดเงินที่ลงทุนในประเทศ',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE9EFF1),
        ),
      );
    } else if (status == "RMF") {
      return Text(
        'กองทุนรวมเพื่อการเลี้ยงชีพ',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE2E9EC),
        ),
      );
    } else if (status == "FIF-EQ") {
      return Text(
        'กองทุนรวมตราสารทุน',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFDCE4E7),
        ),
      );
    } else if (status == "FIF-PF&REIT") {
      return Text(
        'กองทุนรวมหมวดอุตสาหกรรม',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE4EBEE),
        ),
      );
    } else if (status == "EQ") {
      return Text(
        'กองทุนรวมตราสารทุน',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else if (status == "MIX") {
      return Text(
        'กองทุนรวมผสม',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else if (status == "SSF") {
      return Text(
        'SUPER SAVINGS FUND',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else if (status == "SSFX") {
      return Text(
        'SUPER SAVINGS FUND EXTRA',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE1E8EB),
        ),
      );
    } else {
      return Text(
        "Waiting",
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Color(0xFFE6EDF0),
        ),
      );
    }
  }

  Color getColorbar(String fund) {
    if (fund == "Alternative") {
      return Color(0xFF5A0707);
    } else if (fund == "LTF") {
      return Color(0xFF112202);
    } else if (fund == "FI") {
      return Color(0xFF57083F);
    } else if (fund == "MMF") {
      return Color(0xFF1E0429);
    } else if (fund == "RrMF") {
      return Color(0xFF3D4109);
    } else if (fund == "FIF-EQ") {
      return Color(0xFF0B7719);
    } else if (fund == "EQ") {
      return Color(0xFF5F3708);
    } else if (fund == "FIF-PF&REIT") {
      return Color(0xFF0F1172);
    } else if (fund == "MIX") {
      return Color(0xFF870792);
    } else {
      return Color(0xFF585306);
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
      return Color(0xFF1B4607);
    } else {
      return Color(0xFFE41277);
    }
  }

  //color: Color(0xFFEEE3B1),

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
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
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

  DropdownButton<String> showDropdown(double tOTALCOST, String gCode) {
    List<String> showTexts = List();
    showTexts.add("Return");
    showTexts.add(gCode);
    String choseItem;

    return DropdownButton(
        isExpanded: false,
        iconSize: 20.0,
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
          style: GoogleFonts.trirong(
            fontSize: 16.0,
          ),
        ),
        onChanged: (value) {
          print('value ==>> $value');

          changeTabController();
          showListViewsumDatab(gCode);
        });
  }

  void changeTabController() {
    tabController.index = 1;
  }

  Future<void> showListDataDialog(String qcode, int index) async {
    readDataGroup(qcode);

    showDialog(
      context: context,
      builder: (value) => AlertDialog(
        title: Text(resultgroubs[index].fGroupCode),
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

//-----------------------------------------------------
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
                    fontSize: 12.0,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 10.0, 0.0),
                child: new Text(
                  my2Format(uNGL, "uNGL =") + " บาท",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontSize: 12.0,
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
                    fontSize: 12.0,
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
                    fontSize: 12.0,
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
                    fontSize: 12.0,
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
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  //),
                ),
              ),
            ]),
      ],
    ));
  }

  //-----------------------------------------------28-04-2020
  Widget showListViewsumDatab(String qcode) {
    // deleteDataGroup(qcode);
    readDataGroup(qcode);
    return resultgroubs.length == 0
        ? MyStyle().showProcess
        : ListView.builder(
            itemCount: resultgroubs.length,
            itemBuilder: (BuildContext context, int index) {
              return showAllholding(index);
            },
          );
  }

  Widget showListViewsumData2b() {
    return ListView.builder(
      itemCount: resultgroubs.length,
      itemBuilder: (BuildContext context, int index) {
        return showAllholding(index);
      },
    );
  }

  Widget showAllholding(int index) {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      width: MediaQuery.of(context).size.width * 0.7 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showListDataGroub(index),
          showListDataGroubsub3(index),
          showListDataGroubsub2(index),
        ],
      ),
    );
  }
  //รายละเอียดของกองทุน 
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
              color: Color(0xFFFDFDFD),
              width: MediaQuery.of(context).size.width * 0.94 - 10.0,
              child: Text(
                funType,
                style: GoogleFonts.sarabun(
                  fontSize: 14.0,
                  color: Color(0xFF4D3BD4),
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
                  style: MyStyle().h18Style,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  my2Format(marketValue, "marketValue ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontSize: 14.0,
                    color: getColor(marketValue),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

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
                  style: MyStyle().h14Style,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  myPercentFormat(returnPC, "returnPC ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontSize: 12.0,
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
    gainLoss = resultgroubs[index].gainLoss;

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
                  "กำไร (บาท)",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: MyStyle().h14Style,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1.0, 1.0, 5.0),
                child: new Text(
                  my2Format(gainLoss, "gainLoss ="),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sarabun(
                    fontSize: 14.0,
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
                  style: TextStyle(
                      color: MyStyle().deepPurple900,
                      decorationColor: MyStyle().c3),
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
      // itemCount: resultts.length,
      itemBuilder: (BuildContext context, int index) {
        return showAllsum(0);

        //showListFund(index);
      },
    );
  }
//----------------------------------------------------Fund

  Widget showFundSumDatacost() {
    return ListView.builder(
      // itemCount: resultcosts.length,
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
              style: MyStyle().h12Style,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 5.0, 1.0),
            child: new Text(
              formdate,
              textAlign: TextAlign.left,
              style: MyStyle().h10Style,
            ),
          ),
        ]),
      ],
    ));
  }

//รวมยอดการลงทุน
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
                  style: GoogleFonts.trirong(
                    fontSize: 18.0,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 15.0),
                child: new Text(
                  my2Format(gainLoss, "gainLoss ="),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.0,
                  style: GoogleFonts.trirong(
                    fontSize: 16.0,
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "พอร์ตการลงทุน",
              style: GoogleFonts.sarabun(
                fontSize: 20.0,
                color: Color(0xFFE5EBEE),
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
            backgroundColor: Color(0xFF11475C),
            brightness: Brightness.light,
            titleSpacing: 9.0,
            centerTitle: false,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.menu), onPressed: checkExitto2Main),
            ],
            bottom: TabBar(
              controller: tabController,
              indicatorColor: Color(0xFF8F8D14),
              labelColor: Color(0xFFDCE3E6),
              labelStyle: TextStyle(fontSize: 10.0),
              labelPadding: null,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: myTab,
            ),
          ),
          drawer: Container(
            width: 100,
            // height: 5,
            color: Color(0xFFD1DCE0),
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
                  icon: Icon(Icons.assignment_return),
                  tooltip: 'รายการขาย',
                  iconSize: 20.0,
                  color: Colors.white,
                  onPressed: () {},
                ),
                new IconButton(
                  tooltip: 'รายการสับเปลี่ยน',
                  icon: Icon(Icons.account_circle),
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
            color: Color(0xFF11475C),
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
            color: Colors.cyan[80],
          ),
          Container(
            child:
                resultModels.length == 0 ? showProcess() : showListDataFund(),
            height: 320,
            color: Colors.cyan[150],
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
