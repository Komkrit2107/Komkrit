import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';
// import '../models/my_style.dart';
//import '../widget/webholding.dart';
//import '../widget/webpage.dart';
import '../models/normal_dialog.dart';
import '../widget/menus.dart';
import '../widget/agentlookup.dart';
import '../widget/agentlist.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Field
  String users, password;
  int userlevels;

  // Method
  Widget loginButton() {
    return RaisedButton(
      onPressed: () {
        if (users == null ||
            users.isEmpty ||
            password == null ||
            password.isEmpty) {
        } else {
          checkAuthen();
        }
      },
      child: Text('Login'),
    );
  }

  Widget signInButton() {
    return RaisedButton(
      color: Color(0xFF768194),
      child: Text(
        'Sign In',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Colors.cyanAccent[900],
        ),
      ),
      onPressed: () {
        if (users == null ||
            users.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'แจ้งข่าว', 'กรุณา ใส่รหัสผ่่าน');
        } else {
          checkAuthen();
        }
      },
    );
  }

  Widget signUpButton() {
    return RaisedButton(
      color: Color(0xFF768194),
      child: Text(
        'Agent',
        style: GoogleFonts.sarabun(
          fontSize: 16.0,
          color: Colors.blue[900],
        ),
      ),
      onPressed: () {
        if (users == null ||
            users.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'แจ้งข่าว', 'กรุณา ใส่รหัสผ่่าน');
        } else {
          checkAuthenagent();
        }
      },
    );
  }

  Future<void> checkAuthen() async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
    // String url = 'http://115.31.144.227:3009/api/user/login';
    //String url = 'http://10.211.55.5:3009/api/user/login';
    try {
      Map<String, dynamic> map = Map();
      map['email'] = users;
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
            builder: (value) => Menus(
                  userModel: userModel,
                ));

        Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
      }
    } catch (e) {
      print('ERRORRR ===>>> ${e.toString()}');
    }
  }

  Future<void> checkAuthenagent() async {
    String url = 'https://wr.wealthrepublic.co.th:3009/api/user/login';
    //String url = 'http://115.31.144.227:3009/api/user/login';
    // String url = 'http://10.211.55.5:3009/api/user/login';
    try {
      // // Dio Type
      Map<String, dynamic> map = Map();
      map['email'] = users;
      map['password'] = password;

      Map<String, String> headers = Map();
      headers['Content-Type'] = 'application/json';
      var response = await http.post(url, body: map);
      if (response.statusCode == 401) {
        print('Login False');
      } else {
        var result = json.decode(response.body);

        UserModel userModel = UserModel.fromJson(result);
        userlevels = userModel.userLevel;
        //level = 3 --Manager
        if (userModel.userLevel == 3) {
          MaterialPageRoute route = MaterialPageRoute(
              builder: (value) => AgentData(
                    userModel: userModel,
                  ));
          Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
        } else if (userModel.userLevel == 1) {
          MaterialPageRoute route = MaterialPageRoute(
              builder: (value) => CustData(
                    userModel: userModel,
                  ));
          Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
        }
      }
    } catch (e) {
      print('ERRORRR ===>>> ${e.toString()}');
    }
  }

  Widget showsAppName() {
    return Text(
      'SmartFund Link V 1.8+',
      style: GoogleFonts.sarabun(
        fontSize: 16.0,
        color: Color(0xFFC9C2D3),
      ),
    );
  }

  Widget userIdForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextFormField(
              //initialValue: idString,
              decoration: InputDecoration(labelText: 'UserId :'),
            ),
          ),
        ],
      );

  Widget userForm2() {
    return Container(
      width: 240.0,
      height: 30.0,
      child: new TextFormField(
        inputFormatters: [
          new LengthLimitingTextInputFormatter(10),
        ],
        onChanged: (value) {
          users = value.trim();
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            size: 30,
            color: Color(0xFF1C4D2A),
          ),
          hintStyle: GoogleFonts.sarabun(
            fontSize: 18.0,
            color: Colors.blue[900],
          ),
          hintText: 'Username'.trim(),
        ),
        // maxLength: 10,
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 240.0,
      height: 30.0,
      child: TextField(
        obscureText: true,
        onChanged: (value) {
          password = value.trim();
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.vpn_key,
            size: 30,
            color: Color(0xFF51298A),
          ),
          hintStyle: GoogleFonts.sarabun(
            fontSize: 18.0,
            color: Colors.blue[900],
          ),
          hintText: 'Password ',
        ),
        //  maxLength: 20,
      ),
    );
  }

  Widget showListHeader() {
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
              color: Colors.white,
              //width: MediaQuery.of(context).size.width * 0.7 - 10,
              //child: Text("บริษัทหลักทรัพย์นายหน้าซื้อขายหน่วยลงทุน เวลท์ รีพับบลิค จำกัด",
              child: Text(
                "WR Republic",
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w200,
                  fontSize: 35.0,
                  color: Color(0xFF094A86),
                ),
              ),
            ),
          ],
        ),
        new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 10.0),
                // child: new Text("Wealth Republic Mutual Fund Brokerage Securities Co.,Ltd.",
                child: new Text(
                  "",
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.alegreyaSans(
                    fontSize: 25.0,
                    color: Color(0xFF121346),
                  ),
                ),
              ),
            ]),
      ],
    ));
  }

  //Method ให้แสดงส่วนด้านล่าง โดยการเอา แสดง Logo()
  Widget showLogo() {
    return Container(
      height: 90.0,
      child: Image.asset('images/logo12.png'),
    );
  }

  Widget mySizebox50() {
    return SizedBox(
      width: 1.0,
      height: 90.0,
    );
  }

  Widget mySizebox51() {
    return SizedBox(
      width: 1.0,
      height: 50.0,
    );
  }

  Widget mySizebox40() {
    return SizedBox(
      width: 1.0,
      height: 40.0,
    );
  }

  Widget mySizebox20() {
    return SizedBox(
      width: 1.0,
      height: 20.0,
    );
  }

  Widget mySizebox10() {
    return SizedBox(
      width: 10.0,
      height: 10.0,
    );
  }

  webopenMap() async {
    // // Android
    const url = 'https://google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      const url = 'https://google.com';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  webopenApi() async {
    // // Android
    const url = 'https://m.wealthrepublic.co.th';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      const url = 'https://m.wealthrepublic.co.th';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        signInButton(),
        mySizebox10(),
        signUpButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF11475C),
        //backgroundColor: Colors.white,

        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Color(0xFFC9C2D3),
          tooltip: 'เข้าสู่ Website Holding Report',
          onPressed: webopenApi,
        ),
        title: showsAppName(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Color(0xFF376969),
            tooltip: 'ค้นหา',
            onPressed: webopenMap,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[
              Colors.white,
              Color(0xFFF4F4F8),
            ],
            radius: 1.0,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showLogo(),
              mySizebox10(),
              showListHeader(),
              //mySizebox10(),
              userForm2(),
              //userIdForm(),
              mySizebox10(),
              passwordForm(),
              mySizebox20(),
              showButton(),
              mySizebox20(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.adjust),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {},
              tooltip: 'ดูรายละเอียดวันเกิดลูกค้า',
            ),
            IconButton(
              icon: Icon(Icons.assignment_ind),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {},
              tooltip: 'ดูรายละเอียดที่อยู่ลูกค้า',
            ),
          ],
        ),
        color: Color(0xFF11475C),
      ),
    );
  }
}
