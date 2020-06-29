import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/authen.dart';
import '../widget/mcolumn.dart';
import '../models/result_model.dart';
import '../models/user_model.dart';
import '../models/my_style.dart';

class Menus extends StatefulWidget {
  //ต้องการส่งค่า
  final UserModel userModel;
  Menus({Key key, this.userModel}) : super(key: key);

  @override
  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  //Field
  String nameLogin = '';
  String name, user, password;
  String idfund, fundDresscription;

  UserModel currentModel;

  String token, userID;
  List<ResultModel> resultModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    currentModel = widget.userModel;
    token = currentModel.token;
    token = 'Bearer $token';
    userID = currentModel.uSERID;
    nameLogin = currentModel.fULLNAME;
    //password = currentModel.;
    user = currentModel.uSERID;
    //password = "123456";
    //readData();
    //Menus();
  }

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 20.0,
    );
  }

  Widget mySpacce() {
    return SizedBox(
      width: 10.0,
      height: 5.0,
    );
  }

  Widget showTitle() {
    return Text(
      'เมนู',
      style: GoogleFonts.sarabun(
        fontWeight: FontWeight.w200,
        fontSize: 14.0,
        color: Color(0xFFF3F4F7),
      ),
    );
  }

  Widget show2Logo() {
    return Container(
      height: 40.0,
      child: Image.asset('images/logo12.png'),
    );
  }

  Widget menuApps() {
    return FlatButton(
        onPressed: webOpenApi,
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.topLeft, child: Icon(Icons.graphic_eq)),
            Align(
                alignment: Alignment(0.1, -10.0),
                child: Text(
                  "Holding Statment For Your",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 16.0,
                    color: Color(0xFF051750),
                  ),
                ))
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  Widget menuMessase() {
    return FlatButton(
        onPressed: webOpenMessage, // webNews,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.contact_mail,
                color: MyStyle().colorblack,
              ),
            ),
            Align(
                alignment: Alignment(0.34, -10.0),
                child: Text(
                  "ข่าวสารการลงทุน Wealthrepublic",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 16.0,
                    color: Color(0xFF051750),
                  ),
                ))
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  Widget menuMail() {
    return FlatButton(
        onPressed: webOpenMarketing, // webContract,
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.centerLeft, child: Icon(Icons.email)),
            Align(
                alignment: Alignment(0.45, -10.1),
                child: Text(
                  "marketing@wealthrepublic.co.th  ",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 16.0,
                    color: Color(0xFF051750),
                  ),
                ))
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  Widget menuLine() {
    return FlatButton(
        onPressed: examPle, //  webContract,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.code,
                color: MyStyle().colorblack,
              ),
            ),
            Align(
                alignment: Alignment(0.0, -10.0),
                child: Text(
                  "Line@:@wealthrepublic",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 16.0,
                    color: Color(0xFF051750),
                  ),
                ))
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  Widget menuWebsite() {
    return FlatButton(
        onPressed: webOpenWebcompany, // webCompany,
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.bottomLeft, child: Icon(Icons.web)),
            Align(
                alignment: Alignment(0.20, -10.1),
                child: Text(
                  "Website:wealthrepublic.co.th",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 16.0,
                    color: Color(0xFF051750),
                  ),
                ))
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  Widget menuFacebook() {
    return FlatButton(
        onPressed: webOpenFacebook, // webFacebook,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.people_outline)),
            Align(
                alignment: Alignment(-0.30, -10.0),
                child: Text(
                  "Facebook",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 16.0,
                    color: Color(0xFF051750),
                  ),
                ))
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  Widget menuContract() {
    return FlatButton(
        onPressed: () => launch("tel://022666697"), //webContract,
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.centerLeft, child: Icon(Icons.phone)),
            Align(
                alignment: Alignment(0.10, -10.0),
                child: Text(
                  "เบอร์ติดต่อ : 02 266 6697-8",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontSize: 16.0,
                    color: Color(0xFF051750),
                  ),
                ))
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  Widget menuMarketing() {
    return FlatButton(
      onPressed: () {}, // {ReadData(userModel: UserModel)}, // funmenu,

      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Icon(
              Icons.people,
              color: MyStyle().colorblack,
            ),
          ),
          Align(
              alignment: Alignment(-0.10, -10.0),
              child: Text(
                "Agent / สำหรับตัวแทน",
                textAlign: TextAlign.left,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w200,
                  fontSize: 16.0,
                  color: Color(0xFF0B2168),
                ),
              ))
        ],
      ),
    );
  }

  Widget indexMarketing() {
    return FlatButton(
      onPressed: webOpenIndex, // setindex,

      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.nature_people,
                color: MyStyle().colorblack,
              )),
          Align(
              alignment: Alignment(0.10, -10.0),
              child: Text(
                "   " + "ตลาดหลักทรัพย์แห่งประเทศไทย",
                textAlign: TextAlign.left,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.w200,
                  fontSize: 16.0,
                  color: Color(0xFF051750),
                ),
              ))
        ],
      ),
    );
  }

  //แสดงชื่อให้อยู่ในบรรทัดเดียวกัน
  Widget showName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$nameLogin',
          style: GoogleFonts.sarabun(
            fontWeight: FontWeight.w200,
            fontSize: 14.0,
            color: Color(0xFFEAECF1),
          ),
        ),
      ],
    );
  }

  webOpenApi() async {
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

  webOpenIndex() async {
    // // Android
    const url = 'https://marketdata.set.or.th/mkt';
//const url = 'https://settrade.com/C13_MarketSummary.jsp?detail=INDUSTRY';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      const url = 'https://marketdata.set.or.th';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  webOpenMessage() async {
    // // Android
    const url = 'http://wealthrepublic.co.th/news.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      const url = 'http://wealthrepublic.co.th/news.html';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  webOpenWebcompany() async {
    // // Android
    const url = 'http://wealthrepublic.co.th';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      const url = 'http://wealthrepublic.co.th';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  webOpenFacebook() async {
    // // Android
    const url = 'https://www.facebook.com/wealthrepublic';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      const url = 'https://www.facebook.com/wealthrepublic';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  webOpenMarketing() async {
    // // Android
    const url = 'http://wealthrepublic.co.th/contact.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      const url = 'http://wealthrepublic.co.th/contact.html';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Future<void> examPle() async {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyApp();
    });
    Navigator.of(context).push(materialPageRoute);
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
      body: ListView(
        padding: EdgeInsets.all(14.0),
        children: <Widget>[
          show2Logo(),
          mySpacce(),
          mySpacce(),
          menuApps(),
          mySpacce(),
          menuMessase(),
          mySpacce(),
          menuWebsite(),
          mySpacce(),
          menuLine(),
          mySpacce(),
          menuFacebook(),
          mySpacce(),
          menuContract(),
          mySpacce(),
          menuMail(),
          mySpacce(),
          menuMarketing(),
          mySpacce(),
          indexMarketing(),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          showName(),
          //Icon _icon = Icon(LineIcons.code),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: exittoMain,
          ),
        ],
        title: showTitle(),
        backgroundColor: Colors.cyan[800],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.adjust),
              onPressed: () {},
              tooltip: 'ดูรายละเอียดวันเกิดลูกค้า',
            ),
            IconButton(
              icon: Icon(Icons.assignment_ind),
              onPressed: () {},
              tooltip: 'ดูรายละเอียดที่อยู่ลูกค้า',
            ),
          ],
        ),
        color: Colors.cyan[600],
      ),
    );
  }
}
