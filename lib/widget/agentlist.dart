import 'dart:convert';
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart'; //Map userlogin
import '../models/my_style.dart';
import '../widget/authen.dart';
import '../models/result_agent.dart';
import '../widget/agentlookup.dart';

class AgentData extends StatefulWidget {
  final UserModel userModel;
  AgentData({Key key, this.userModel}) : super(key: key);

  @override
  _AgentDataState createState() => _AgentDataState();
}

class _AgentDataState extends State<AgentData> {
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

  String search;

  List<Resultgent> resultgents = List();

  // final Debouncer debouncer = Debouncer(milliseconds: 0);

  // Method
  @override
  void initState() {
    super.initState();
    currentModel = widget.userModel;
    token = currentModel.token;
    token = 'Bearer $token';
    userID = currentModel.uSERID.trim();
    mkid = currentModel.mktId.toString(); //Agent saleid
    password = "123456";
    displayNames = currentModel.fULLNAME;
    reaAgentdData();
  }

  Future<void> reaAgentdData() async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/wr/groupagent/$mkid';
    // String url = 'http://115.31.144.227:3009/api/wr/groupagent/$mkid';
    // String url = 'http://10.211.55.5:3009/api/wr/groupagent/$mkid';

    Map<String, String> headers = Map();
    headers['Authorization'] = token;

    http.Response response = await http.get(url, headers: headers);
    var result = json.decode(response.body);
    print('result ===>>> $result');

    var myResult = json.decode(response.body)['result'];
    for (var map in myResult) {
      Resultgent resultgent = Resultgent.fromJson(map);
      setState(() {
        resultgents.add(resultgent);
      });
    }
  }

  Future<void> checkAuthenagent() async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
    //String url = 'http://115.31.144.227:3009/api/user/login';
    // String url = 'http://10.211.55.5:3009/api/user/login';

    try {
      // // Dio Type
      Map<String, dynamic> map = Map();
      map['email'] = idlogin;
      map['password'] = password;

      Map<String, String> headers = Map();
      headers['Content-Type'] = 'application/json';
      var response = await http.post(url, body: map);
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

  Widget showContent2(int index) {
    return Card(
      child: Column(
        children: <Widget>[
          //showAmcName(index),
          getIdnumber2(index),
        ],
      ),
    );
  }

  Widget getIdnumber2(int index) {
    return FlatButton(
      padding: EdgeInsets.all(8.0),
      onPressed: () {
        checkMenuId(index);
      }, // seti
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "",
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              resultgents[index].fullName,
              textAlign: TextAlign.left,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                color: Color(0xFF2F0746),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_drop_down,
                size: 40.0,
                color: MyStyle().blue900,
              )),
        ],
      ),
    );
  }

  int getNumber(int selector) {
    if (selector <= 0) {
      return selector + 1;
    } else {
      return selector += 1;
    }
  }

  Widget showAmcName(int index) => Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Text(
              getNumber(index).toString() + ' ' + resultgents[index].fullName,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                color: Color(0xFF2F0746),
              ),
            ),
          ),
          Align(
              
              child: Icon(
                Icons.arrow_forward_ios,
                size: 25.0,
                color: MyStyle().blue900,
              )),
        ],
      );

  Widget showTitle() {
    return Text(
      'List Agent Name',
      style: GoogleFonts.antic(
        fontSize: 14.0,
        color: Color(0xFFD8E4D3),
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

  Future<void> checkMenuId(int index) async {
    currentModel.mktId = resultgents[index].userId;
    currentModel.fULLNAME = resultgents[index].fullName;
    MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => CustData(userModel: currentModel));
    Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
  }

  //แสดงชื่อให้อยู่ในบรรทัดเดียวกัน
  Widget showLonginName2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$displayNames',
          style: GoogleFonts.antic(
            fontSize: 16.0,
            color: Color(0xFFD8E4D3),
          ),
        ),
      ],
    );
  }

  Widget showListView2() {
    return Column(
      children: <Widget>[
        //showSearch(), ค้นหาออกไป
        Expanded(
          child: ListView.builder(
            itemCount: resultgents.length,
            itemBuilder: (BuildContext context, int index) {
              return showContent2(index);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: showTitle(),
        actions: <Widget>[
          showLonginName2(),
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 20.0,
            ),
            onPressed: webExittoMain,
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: resultgents.length == 0 ? showProcess() : showListView2(),
        ),
      ),
    );
  }
}
