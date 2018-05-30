import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/auth.dart';

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
  final formKey = new GlobalKey<FormState>();
  String _email, _password, _passwordConfirm;

  Future validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_password == _passwordConfirm) {
        try {
          await new Auth().createUserWithEmailAndPassword(_email, _password);
        } catch(e) {
          print(e);
        }
      }
      else {
        print("Senhas não conferem.");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title),),
      body: new ListView(
        padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 0.0),
        children: <Widget>[
            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: new TextFormField(
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: "Senha",
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (value) => value.isEmpty
                          ? "senha precisa ser preenchido"
                          : null,
                      onSaved: (value) => this._password = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
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
                    ),
                  ),
                ],
              ),
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
            new FlatButton(
              child: new Text(
                "Já possui cadastro?",
                style: TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/Login");
              },
            ),
          ],
        
      ), 
    );
  }
}