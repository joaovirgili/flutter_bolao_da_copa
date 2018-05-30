import 'package:flutter/material.dart';

import '../views/login.dart';
import '../utils/auth.dart';

import '../main.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;
  @override
  _RootPageState createState() => new _RootPageState();
}

enum AuthStatus { signedIn, notSignedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((user) {
      setState(() {
        _authStatus =
            user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new Login();
      case AuthStatus.signedIn:
        return new Main(
          title: "Bolão do É Nóis!",
          auth: widget.auth,
        );
    }
  }
}
