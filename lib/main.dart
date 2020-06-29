import 'package:flutter/material.dart';
import 'package:kritproduct/widget/authen.dart';
//import 'package:kritproduct/widget/bar_test.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authen(),
      //home: AppBarBottomSample(),
    );
  }

}