import 'package:flutter/material.dart';

import '../utils/auth.dart';


class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.title, this.auth}) : super(key: key);

  static const String routeName = "/UserProfile";
  final String title;
  final BaseAuth auth;
  
  @override
  _UserProfileState createState() => new _UserProfileState(title: title, auth:auth);
}

class _UserProfileState extends State<UserProfile> {
  _UserProfileState({this.title, this.auth});

  final String title;
  final BaseAuth auth;

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