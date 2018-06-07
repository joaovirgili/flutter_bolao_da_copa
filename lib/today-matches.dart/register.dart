import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/auth.dart';
import '../utils/singleton.dart';

class Register extends StatefulWidget {
  Register({Key key, this.title, this.auth}) : super(key: key);
  final String title;
  final BaseAuth auth;
  static const String routeName = "/Register";

  @override
  _RegisterState createState() => new _RegisterState(title: title, auth: auth);
}

class _RegisterState extends State<Register> {
  _RegisterState({this.title, this.auth});
  final String title;
  final BaseAuth auth;
  final formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  FocusNode _focus = new FocusNode();
  FocusNode _focus2 = new FocusNode();
  FocusNode _focus3 = new FocusNode();

  @override
  initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _focus2.addListener(_onFocusChange);
    _focus3.addListener(_onFocusChange);
  }

  _onFocusChange() {
    _scrollController.position.maxScrollExtent;
  }

  String _email, _password, _passwordConfirm;

  Future validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_password == _passwordConfirm) {
        try {
          Singleton().showLoadingDialog(scaffoldKey.currentState.context);
          await new Auth().createUserWithEmailAndPassword(_email, _password);
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, "/AddInfo", (v) => false);
        } catch (e) {
          print(e);
          Navigator.pop(context);
          scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Cadastro não realizado, consulte adminstrador."),
            duration: new Duration(seconds: 3),
          ));
        }
      } else {
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Senha não conferem"),
          duration: new Duration(seconds: 3),
        ));
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: Center(
        child: new ListView(
          padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
          shrinkWrap: true,
          reverse: true,
          controller: _scrollController,
          children: <Widget>[
            new FlatButton(
              child: new Text(
                "Já possui cadastro?",
                style: TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/Login");
              },
            ),
            new Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.red.shade100,
                elevation: 5.0,
                child: MaterialButton(
                  height: 42.0,
                  onPressed: () {
                    validateAndSave();
                  },
                  color: Theme.of(context).primaryColor,
                  child: new Text(
                    "Cadastrar",
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Hero(
                      tag: "hero",
                      child: new Image.asset(
                        "assets/eh_nois.jpg",
                        repeat: ImageRepeat.noRepeat,
                        width: 200.0,
                        height: 200.0,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: "Email",
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) => value.isEmpty
                            ? "E-mail precisa ser preenchido"
                            : null,
                        onSaved: (value) => this._email = value,
                        focusNode: _focus2,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new TextFormField(
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: "Senha",
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (value) =>
                          value.isEmpty ? "senha precisa ser preenchido" : null,
                      onSaved: (value) => this._password = value,
                      focusNode: _focus3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new TextFormField(
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: "Confirmar senha",
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (value) => value.isEmpty
                          ? "Confirmar senha precisa ser preenchido"
                          : null,
                      onSaved: (value) => this._passwordConfirm = value,
                      focusNode: _focus,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
