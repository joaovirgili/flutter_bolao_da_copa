import 'package:flutter/material.dart';

import '../views/login.dart';
import '../views/add-user-info.dart';

import '../utils/auth.dart';

import '../main.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;
  @override
  _RootPageState createState() => new _RootPageState();
}

enum AuthStatus { signedIn, notSignedIn, addInfo }

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((user) {
      setState(() {
        // _authStatus =
        //     user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        if (user == null) {
          _authStatus = AuthStatus.notSignedIn;
        } else if (user.displayName == null) {
          _authStatus = AuthStatus.addInfo;
        } else {
          _authStatus = AuthStatus.signedIn;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new Login(auth: widget.auth,);
      case AuthStatus.signedIn:
        return new Main(
          title: "Bolão do É Nóis!",
          auth: widget.auth,
        );
      case AuthStatus.addInfo:
        return new AddUserInfo(title: "Completar cadastro", auth: widget.auth,);
    }
  }
}
