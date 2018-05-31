import 'package:flutter/material.dart';
import '../utils/auth.dart';
import 'package:camera/camera.dart';

class AddUserInfo extends StatefulWidget {
  AddUserInfo({this.title, this.auth});
  final BaseAuth auth;
  final String title;
  static const String routeName = "/AddInfo";
  

  @override
  _AddUserInfoState createState() => new _AddUserInfoState(title: title, auth: auth);
}

class _AddUserInfoState extends State<AddUserInfo> {
  _AddUserInfoState({this.auth, this.title});
  final BaseAuth auth;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(child: new Text("Adicionar mais informações (foto e nome).")),
    );
  }
}