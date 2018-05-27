import 'package:flutter/material.dart';


class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.title}) : super(key: key);

  static const String routeName = "/UserProfile";
  final String title;
  
  @override
  _UserProfileState createState() => new _UserProfileState(title: title);
}

class _UserProfileState extends State<UserProfile> {
  _UserProfileState({this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Material(
        child: new Scaffold(
          appBar: new AppBar(title: new Text(this.title),),
          body: new Center(child: new Text(title),)),
      ),
    );
  }
}