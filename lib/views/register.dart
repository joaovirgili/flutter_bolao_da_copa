import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({Key key, this.title}) : super(key: key);
  final title;
  static const String routeName = "/Register";

  @override
  _RegisterState createState() => new _RegisterState(title: title);
}

class _RegisterState extends State<Register> {
  _RegisterState({this.title});
  final title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title),),
      body: new ListView(
        children: <Widget>[],
        
      ), 
    );
  }
}