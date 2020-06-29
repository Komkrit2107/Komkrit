import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:kritproduct/models/my_style.dart';

class TestWebView extends StatefulWidget {
  @override
  _TestWebViewState createState() => _TestWebViewState();
}

class _TestWebViewState extends State<TestWebView> {
  // Field
  String url = 'https://m.wealthrepublic.co.th';
  

  // Method
  Widget showWebView() {
    return WebviewScaffold(
      url: url,
      hidden: true,
      withJavascript: true,

    );
  }

Widget showHoldingreport() {
return Text(
  'Holding Report',
  style: TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: MyStyle().b1,
  ),
);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showHoldingreport(),
      ),
      body: showWebView(),
    );
  }
}