import 'package:flutter/material.dart';
//import 'package:http/browser_client.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:kritproduct/models/my_style.dart';
import 'package:url_launcher/url_launcher.dart';

class  Webpageshow  extends StatefulWidget {
  @override
  _WebpageshowState createState() => _WebpageshowState();
}

class _WebpageshowState extends State<Webpageshow> {
  // Field
  //String url = 'http://wealthrepublic.co.th';
  String url = 'https://google.com/';
  //String URL = 'http://flutter.io';

  // Method
  Widget showWebpage() {
    return WebviewScaffold(
      url: url,
      hidden: true,
      withJavascript: true,
      withLocalStorage: true,
    );
  }

webopenMap() async {
   // // Android
  const url = 'geo:52.32,4.917';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
     // iOS
  const url = 'https://maps.apple.com/?ll=52.32,4.917';
  if (await canLaunch(url)) {
    await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}





Widget showGoogle() {
return Text(
  'Google',
  style: TextStyle(
    fontFamily: 'Raleway',
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: MyStyle().deepPurple900,
  ),
);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showGoogle(),
        backgroundColor: MyStyle().barColor,
      ),
      body: showWebpage(),
    );
  }
}