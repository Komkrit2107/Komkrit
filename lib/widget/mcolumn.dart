import 'package:flutter/material.dart';
import '../widget/authen.dart';
void main() {
 // runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter ',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: new MyHomePage(title: 'Smart Fund Link+'),
    );
  }
}




class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  

  @override
  Widget build(BuildContext context) {

    final cols1 = [
      new DataColumn(label: const Text('Column title 1'),),
      ];

    final cols2 = [
      new DataColumn(
        label: const Text('Fund'),
      ),
      new DataColumn(
        label: const Text('Nav'),
      ),
    ];

    final rows1 = new List.generate(1, (_) =>
    new DataRow(cells: [new DataCell(new Text('loooooonnnnnng')),]));

    final rows2 = new List.generate(3, (_) =>
        new DataRow(cells: [
              new DataCell(new Text('1')),
              new DataCell(new Text('3')),
            ]));

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      actions: <Widget>[
      IconButton(
      icon: Icon(
      Icons.exit_to_app,
      color: Colors.white,
      size: 20.0,  ),
      onPressed:(){Authen();}, // checkExittoMain,
      ),
      ],),
      body: new Column(
        children: [
          new Material(child: new DataTable(columns: cols1, rows: rows1),),
          new Padding(padding: const EdgeInsets.only(top: 10.0)),
          new Material(child: new DataTable(columns: cols2, rows: rows2),
          ),
        ],
      ),
    );
  }
}