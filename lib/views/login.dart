import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  void validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print(await Auth().signInWithEmailAndPassword(_email, _password));
      print("Usuario: $_email e senha: $_password");
    } else {
      print("Form invalidado.");
    }  
      
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: new ListView(
          padding: const EdgeInsets.only(top: 100.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: new Hero(
                tag: "hero",
                child: new Image.asset(
                  "assets/world-cup-logo.png",
                  repeat: ImageRepeat.noRepeat,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
            ),
            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
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
                          hintText: "Password",
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (value) => value.isEmpty
                          ? "Password precisa ser preenchido"
                          : null,
                      onSaved: (value) => this._password = value,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new FlatButton(
                        child: new Text(
                          "Esqueceu a senha?",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12.0),
                        ),
                        onPressed: () {},
                      ),
                    ],
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
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, "/Main", (v) => false);
                        },
                        color: Theme.of(context).primaryColor,
                        child: new Text(
                          "Log in",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            new FlatButton(
              child: new Text(
                "Ainda não tem cadastro?",
                style: TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/Register");
              },
            ),
          ],
        ),
      ),
    );
  }
}
