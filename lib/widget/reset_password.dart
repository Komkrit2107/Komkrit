import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/normal_dialog.dart';
import '../models/user_model.dart';
import '../widget/authen.dart';

class ResetPassword extends StatefulWidget {
  final UserModel userModel;
  ResetPassword({Key key, this.userModel}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // Field
  UserModel userModel;
  String idString, loginName, password, rePassword;

  // Method
  @override
  void initState() {
    super.initState();
    setState(() {
      userModel = widget.userModel;
      idString = userModel.uSERID;
      loginName = userModel.loginName;
      print('id ==>> $idString, loginName ==>> $loginName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
        ),
      ),
      body: Column(
        children: <Widget>[
          mySizebox10(),
          showLogo4(),
          userLoginForm(),
          userIdForm(),
          passwordForm(),
          rePasswordForm(),
          showButton(),
        ],
      ),
    );
  }

  RaisedButton saveButton() => RaisedButton(
        child: Text('Save'),
        onPressed: () {
          if (password == null ||
              password.isEmpty ||
              rePassword == null ||
              rePassword.isEmpty) {
            normalDialog(context, 'Have Space', 'Type Password and RePassword');
          } else if (password != rePassword) {
            normalDialog(context, 'Password not Math', 'Type Password Agains');
          } else {
            resetPassword();
          }
        },
      );

  Future<void> resetPassword() async {
    //String url = 'http://115.31.144.227:3009/api/user/resetPassword';
    String url = 'http://wr.wealthrepublic.co.th:3009/api/user/resetPassword';
    Map<String, String> headers = {"Content-Type": "application/json"};
    String postBody =
        '{"LoginName":"$loginName","newPassword":"$password","id":"$idString"}';

    Response response = await post(url, headers: headers, body: postBody);
    int statusCode = response.statusCode;
    print('statusCode ===>> $statusCode');
    print('response ==>> ${response.body}');

    if (statusCode == 200) {
      MaterialPageRoute route = MaterialPageRoute(builder: (value) => Authen());
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    } else {
      normalDialog(context, 'Not Complete', 'Please Try Again');
    }
  }

  Widget userLoginForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextFormField(
              initialValue: loginName,
              decoration: InputDecoration(labelText: 'UserLogin :'),
            ),
          ),
        ],
      );

  Widget userIdForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextFormField(
              initialValue: idString,
              decoration: InputDecoration(labelText: 'UserId :'),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              obscureText: true,
              onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(labelText: 'Password :'),
            ),
          ),
        ],
      );

  Widget rePasswordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              obscureText: true,
              onChanged: (value) => rePassword = value.trim(),
              decoration: InputDecoration(labelText: 'Re-Password :'),
            ),
          ),
        ],
      );

  Widget mySizebox10() {
    return SizedBox(
      width: 10.0,
      height: 10.0,
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[saveButton(), mySizebox10(), signOutButton()],
    );
  }

  RaisedButton signOutButton() => RaisedButton(
        child: Text('Cancel'),
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => Authen());
          Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
        },
      );

  Widget showLogo4() {
    return Container(
      height: 80.0,
      child: Image.asset('images/logo12.png'),
    );
  }
}
