import 'dart:convert';
//import 'dart:io';
//import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:kritproduct/models/result_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

import '../widget/authen.dart';
import '../models/agentcustomer.dart';
import '../widget/reset_password.dart';
import '../widget/holdingnew.dart';
import '../models/user_model.dart'; //Map userlogin
import '../models/result_cost.dart';
import '../models/result_total.dart';
import '../models/normal_dialog.dart';
import '../widget/agentlist.dart';

class CustData extends StatefulWidget {
  final UserModel userModel;
  CustData({Key key, this.userModel}) : super(key: key);

  @override
  _CustDataState createState() => _CustDataState();
}

List<Widget> myTab = <Widget>[
  Tab(
    text: "My InveesMent",
    icon: Icon(Icons.chat),
  ),
  Tab(text: "My Protfolio", icon: Icon(Icons.group)),
  Tab(text: "Historcal Return", icon: Icon(Icons.announcement))
];

List<Resultt> resultts = List();
List<Resultcost> resultcosts = List();

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (timer != null) {
      timer.cancel();
    }

    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _CustDataState extends State<CustData>
    with SingleTickerProviderStateMixin {
  // Field
  UserModel currentModel;
  String token, userID;
  String saleid, mkid;
  String startDate = "2020/01/01";
  String endDate = "2020/03/31";
  String password;
  String displayNames;
  String idlogin;
  String searchString;
  int mkidold;
  int idno;

  String search;

  //List<ResultModel> resultModels = List();
  List<ResultCus> resultCutss = List(); //ดึงข้อมูลจาก View
  List<ResultCus> resultCutssSearch = List();
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    currentModel = widget.userModel;
    token = currentModel.token;
    token = 'Bearer $token';
    userID = currentModel.uSERID.trim();
    mkid = currentModel.mktId.toString(); //Agent saleid
    password = "123456";
    displayNames = currentModel.fULLNAME;
    mkidold = currentModel.mktId; //Agent saleid
    readData();
    readDataCost();
  }

  Future<int> sumStream(Stream<int> stream) async {
    var sum = 0;
    await for (var value in stream) {
      sum += value;
    }
    return sum;
  }

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }

// int getNumber(int selector) {
  var m = 0;

  Future<void> readData() async {
    //String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/summary/$userID';
    // String url = 'http://115.31.144.227:3009/api/wr/transactionMarket/$mkid?fromDate=$startDate&toDate=$endDate';
//String url = 'http://10.211.55.5:3009/api/wr/transactionMarket/$mkid?fromDate=$startDate&toDate=$endDate';
    String url =
        'https://wr.wealthrepublic.co.th:3009/api/wr/transactionMarket/$mkid?fromDate=$startDate&toDate=$endDate';

    // 10.211.55.5:3009

    Map<String, String> headers = Map();
    headers['Authorization'] = token;

    http.Response response = await http.get(url, headers: headers);
    var result = json.decode(response.body);
    print('result ===>>> $result');

    var myResult = json.decode(response.body)['result'];
    for (var map in myResult) {
      ResultCus resultcutss = ResultCus.fromJson(map);
      setState(() {
        resultCutss.add(resultcutss);
        resultCutssSearch.add(resultcutss);
      });
      //print('resultCutss.lenght ===>>>  ${resultCutss.length}');
      //print('จำนวนรายการทั้งหมด ===>>>  ${resultCutss.length}');
    }
  }

  Widget showProcess() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showContent(int index) {
    return Card(
      shadowColor: Color(0xFF0E0D0D),
      child: Column(
        children: <Widget>[
          showAmcName(index),
        ],
      ),
    );
  }

  Widget showContent2(int index) {
    return Card(
      shadowColor: Color(0xFF0E0D0D),
      child: Column(
        children: <Widget>[
          getIdnumber(index),
          getTelephne(index),
          getHBD(index),
          showEmailcustomer(index),
        ],
      ),
    );
  }

  Widget getHBD(int index) {
    String dataDate = resultCutssSearch[index].birthDay;
    DateTime todayDate = DateTime.parse(dataDate);
    String formdate = formatDate(todayDate, [dd, '-', mm, '-', yyyy]);
    return FlatButton(
      //colorBrightness: Brightness.dark,
      //color: Color(0xFF0E0D0D),
      //highlightColor:Color(0xFF0E0D0D),
      onPressed: () {}, //() {checkAuthenId(index);}, // setin
      textColor: Color(0xFF0E0D0D),
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.audiotrack,
                size: 25.0,
                color: Color(0xFFE9633A),
              )),
          Align(
              alignment: Alignment.topRight,
              child: Text(
                formdate,
                textAlign: TextAlign.right,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.00,
                  color: Color(0xFF0D0D0E),
                  //backgroundColor: Color(0xFFEFF5F3),
                ),
              ))
        ],
      ),
    );
  }

  Widget getEmail(int index) {
    return FlatButton(
      child: Text('Sign Up',
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 10.0)),
      onPressed: () => {},
      color: Colors.white,
    );
  }




  Widget getTelephne(int index) {
    return FlatButton(
      //colorBrightness: Brightness.dark,
      //color: Color(0xFF0E0D0D),
      onPressed: () => launch("tel://" + resultCutssSearch[index].loginName),
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.phone_in_talk,
                size: 25.0,
                color: Color(0xFFD14D36),
              )),
          Align(
              alignment: Alignment.topRight,
              child: Text(
                resultCutss[index].loginName,
                textAlign: TextAlign.right,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: Color(0xFF0F0F0F),
                  //backgroundColor: Color(0xFFEFF5F3),
                ),
              ))
        ],
      ),
    );
  }

  Widget getIdnumber(int index) {
    return FlatButton(
      //colorBrightness: Brightness.dark,
      //color: Color(0xFF0E0D0D),
      onPressed: () {
        checkMenuId(index);
      }, // seti
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.people_outline,
                size: 25.0,
                color: Color(0xFFD14D36),
              )),
          Align(
              alignment: Alignment.topRight,
              child: Text(
                resultCutssSearch[index].custCode,
                textAlign: TextAlign.right,
                style: GoogleFonts.sarabun(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F0F0F),
                  // backgroundColor: Color(0xFFEFF5F3),
                ),
              )),
        ],
      ),
    );
  }

  Widget showEmailcustomer(int index) {
    return FlatButton(
      //colorBrightness: Brightness.dark,
      //color: Color(0xFF0E0D0D),
      onPressed: webopenGmail,
      // seti
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.mail_outline,
                size: 25.0,
                color: Color(0xFFD14D36),
              )),
          Align(
              alignment: Alignment.topRight,
              child: Text(
                resultCutssSearch[index].email,
                textAlign: TextAlign.right,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: Color(0xEA0B0C0C),
                  //backgroundColor: Color(0xFFEFF5F3),
                ),
              )),
        ],
      ),
    );
  }

  Widget searchForm() {
    return Container(
      //decoration: Colors.accents,
      color: Colors.white,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
      child: ListTile(
        trailing: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('searchString ===>>> $searchString');

              setState(() {
                readData();
              });
            }),
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
          ),
          onChanged: (String string) {
            searchString = string.trim();
          },
        ),
      ),
    );
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

  Color getColor(double selector) {
    if (selector >= 0.001) {
      return Color(0xFF12A70D);
    } else {
      return Color(0xFFD50000);
    }
  }

  String my2Format(double myDouble, String title) {
    print('myDouble ==> $myDouble');
    NumberFormat numberFormat = NumberFormat('#,##0.00');
    return numberFormat.format(myDouble);
  }

//รวมยอดการลงทุน Header Page#1
  Widget showSumPort(int index) {
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

  Widget myWidget() {
    return FractionallySizedBox(
      widthFactor: 0.7,
      heightFactor: 0.3,
      child: Container(
        color: Color(0xFFEFF5F3),
      ),
    );
  }

  String myFormatint(int myDoubleint, String title) {
    NumberFormat numberFormat = NumberFormat('#');
    return numberFormat.format(myDoubleint);
  }

  String myFormat(double myDouble, String title) {
    NumberFormat numberFormat = NumberFormat('#,###.####');
    return numberFormat.format(myDouble);

    // return '$title ${myDouble.toStringAsFixed(myDouble.truncateToDouble() == myDouble ? 0 : 2)}';
  }

  int getNumber(int selector) {
    if (selector <= 0) {
      return selector + 1;
    } else {
      return selector += 1;
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

  List<int> myIndexs = List();

  Widget showListCustomerName(int index) {
    myIndexs.add(index);
    double tOTALCOST = resultts[index].tOTALCOST;
    String gCode = resultts[index].fUNDTYPE.trim();


    // tOTALs.add(tOTALCOST); //บวกยอดเข้าไป
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
                      showDropdown(tOTALCOST, gCode),  //รายการลูกค้ามาแสดง
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
          setState(() {
            changeTabController();
          });
          //showPage2sumDatab(gCode); //Call Data
        });
  }

  
  void changeTabController() {
    tabController.index = 1; //มีปัญหาตรงจุดนี้แหละ
  }

  Widget showAmcName(int index) => Row(
        children: <Widget>[
          Container(
            //color: Color(0xFF0C0C0C),
            //width: MediaQuery.of(context).size.width - 20,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Text(
              getNumber(index).toString() +
                  ") " +
                  resultCutssSearch[index].fullNamess.trim(),
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w200,
                fontSize: 16.0,
                color: Color(0xFF094A86),
              ),
            ),
          ),
          IconButton(
            icon:
                Icon(Icons.arrow_drop_down, size: 35, color: Color(0xFF063B2A)),
            onPressed: () {
              setState(() {
                changeTabController();
              });
              showListView2(index);
            },
            tooltip: 'ดูรายละเอียดลูกค้า',
          ),
        ],
      );

  Widget showTitle() {
    return Text(
      'Agent Name',
      style: GoogleFonts.sarabun(
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        color: Color(0xFFF1ECF3),
      ),
    );
  }

  Future<void> webExittoMain() async {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return Authen();
    });
    Navigator.of(context).push(materialPageRoute);
  }

  Future<void> checkAuthenId(int index) async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
    //String url = 'http://192.168.24.131:3009/api/user/login';
    //String url = 'http://115.31.144.227:3009/api/user/login';
    // String url = 'http://10.211.55.5:3009/api/user/login';

    password = '123456'; //resultCutss[index].pASSWD;
    idlogin = resultCutss[index].loginName;
    // var hashedPassword =
    // new DBCrypt().hashpw(password, new DBCrypt().gensalt());

    try {
      Map<String, dynamic> map = Map();
      map['email'] = idlogin;
      map['password'] = password;

      //print('เข้าระบบไม่สำเร็จ โปรดตรวจสอบ $hashedPassword');

      Map<String, String> headers = Map();
      headers['Content-Type'] = 'application/json';

      var responsex = await http.post(url, body: map);
      //var result = json.decode(responsex.body);

      if (responsex.statusCode == 401) {
        print('เข้าระบบไม่สำเร็จ โปรดตรวจสอบ $idlogin');
      } else {
        var result = json.decode(responsex.body);

        UserModel userModel = UserModel.fromJson(result);
        MaterialPageRoute route = MaterialPageRoute(
            builder: (value) => HoldingDatanew(userModel: userModel));
        Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
      }
    } catch (e) {
      print('ERRORRR ===>>> ${e.toString()}');
    }
  }

  Future<void> checkMenuId(int index) async {
    currentModel.uSERID = resultCutssSearch[index].custCode;
    currentModel.fULLNAME = resultCutssSearch[index].fullName;
    MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => HoldingDatanew(userModel: currentModel));
    Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
  }

  Future<void> checkMenuAgent() async {
    currentModel.uSERID = userID;
    // currentModel.fULLNAME = resultCutssSearch[index].fullName;
    if (currentModel.userLevel == 3) {
      MaterialPageRoute route = MaterialPageRoute(
          builder: (value) => AgentData(userModel: currentModel));
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    } else {
      webExittoMain();
    }
  }

  //แสดงชื่อให้อยู่ในบรรทัดเดียวกัน
  Widget showLonginName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$displayNames',
          style: GoogleFonts.sarabun(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: Color(0xFFF1ECF3),
          ),
        ),
      ],
    );
  }

  Widget showListView() {
    return Column(
      children: <Widget>[
        showSearch(),
        Expanded(
          child: ListView.builder(
            itemCount: resultCutssSearch.length,
            //itemCount: resultcosts.length,
            itemBuilder: (BuildContext context, int index) {
              return showListCustomerName(index);
              //return showContent(index);

            },
          ),
        ),
      ],
    );
  }

  Widget showListView2(int idno) {
    //return Column(
    //children: <Widget>[
    //showSearch(),
    // Expanded(
    //child: ListView.builder(
    // itemCount: resultCutssSearch.length,
    //itemCount: resultcosts.length,
    //itemBuilder: (BuildContext context, int index) {
    return showContent2(idno);
    //},
    //),
    //   ),
    ////],
    //);
  }

  Widget showSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          color: Color(0xFFFDFDFD),
          height: 8.5,
          child: TextField(
            onChanged: (value) {
              debouncer.run(() {
                resultCutssSearch = resultCutss
                    .where((search) => search.fullNamess
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
        ),
        IconButton(
            iconSize: 30.0,
            icon: Icon(Icons.search),
            color: Color(0xFF13520B),
            onPressed: () {
              if (search == null || search.isEmpty) {
                normalDialog(context, 'Have Space', 'Please Fill Every Blank');
              } else {
                checkSearch();
              }
            })
      ],
    );
  }

  Future<void> checkSearch() async {
    for (var model in resultCutss) {
      if (search == model.fullNamess) {
      } else {}
    }
  }

  webopenHolding() async {
    // url: 'http://localhost:3009/api/wr/summary/' + custId,
    const url = 'https://m.wealthrepublic.co.th/holding/holding-report.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      const url = 'https://m.wealthrepublic.co.th/holding/holding-report.html';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  webopenGmail() async {
    // url: 'http://localhost:3009/api/wr/summary/' + custId,
    const url = 'https://gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      const url = 'https://gmail.com';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  // return Scaffold(
  // backgroundColor: Colors.white,
  // appBar: AppBar(
  ///backgroundColor: Colors.white,
  // title: showTitle(),
  // actions: <Widget>[
  // showLonginName(),
  // IconButton(
  // icon: Icon(
  // Icons.home,
  // color: Colors.white,
  // size: 25.0,
  // ),
  // onPressed: checkMenuAgent, //webExittoMain, //() {},
  ///onPressed : () {searchForm();},
  // ),
  // ],
  // ),
  /// body: Center( child: _widgetOptions.elementAt(_sele
  // body: resultCutss.length == 0 ? showProcess() : showListView(),
  // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  // bottomNavigationBar: BottomAppBar(
  // child: new Row(
  // mainAxisSize: MainAxisSize.max,
  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  // children: <Widget>[
  // IconButton(
  // icon: Icon(
  // Icons.vpn_key,
  // color: Color(0xFFEFF5F3),
  // ),
  // onPressed: () {
  // MaterialPageRoute route = MaterialPageRoute(
  // builder: (value) => ResetPassword(
  // userModel: currentModel,
  // ));
  // Navigator.of(context)
  // .pushAndRemoveUntil(route, (value) => false);
  // },
  // tooltip: 'Reset Password',
  // ),
  // IconButton(
  // icon: Icon(Icons.assignment_ind, color: Color(0xFFEFF5F3)),
  // onPressed: () {},
  // tooltip: 'ดูรายละเอียดที่อยู่ลูกค้า',
  // ),
  // ],
  // ),
  // color: Colors.black,
  // ),
  // );
  // }
// }

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
                  onPressed: () {},
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
              IconButton(icon: Icon(Icons.home), onPressed: () {}),
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
              //resultCutss.length == 0 ? showProcess() : showListView(),
              myInvessment(),
              // showListViewsumData2b(),
              // showListViewsumData(),
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
                    Icons.vpn_key,
                  ),
                  tooltip: 'Reset Password',
                  iconSize: 20.0,
                  color: Colors.white,
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                        builder: (value) => ResetPassword(
                              userModel: currentModel,
                            ));
                    Navigator.of(context)
                        .pushAndRemoveUntil(route, (value) => false);
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
            child: resultCutss.length == 0 ? showProcess() : showListView(),
            height: 100,
            color: Color(0xFF0C0C0C),
          ),
          Container(
            child: resultCutss.length == 0 ? showProcess() : showListView(),
            height: 360,
            color: Color(0xFF0C0C0C),
          ),

          //showTotal(), //รวมยอดทั้งหมด
        ],
      ),
    );
  }
}
