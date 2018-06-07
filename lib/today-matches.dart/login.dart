import 'package:flutter/material.dart';
import '../utils/singleton.dart';
import '../utils/auth.dart';

class Login extends StatefulWidget {
  Login({this.auth});

  final BaseAuth auth;
  static const String routeName = "/Main";

  @override
  _LoginState createState() => new _LoginState(auth: auth);
}

class _LoginState extends State<Login> {
  _LoginState({this.auth});

  final formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  final BaseAuth auth;

  void validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        await auth.signInWithEmailAndPassword(_email, _password);
          Navigator.pop(context);
        auth.currentUser().then((user) {
          if (user.displayName == null) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/AddInfo", (v) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, "/Main", (v) => false);
          }
        });
      } catch (e) {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Email e/ou senha inválido"),
        duration: new Duration(seconds: 3),
      ));
        print(e);
      }
    }
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: new Hero(
                  tag: "hero",
                  child: new Image.asset(
                    "assets/world-cup-logo.png",
                    repeat: ImageRepeat.noRepeat,
                    width: 250.0,
                    height: 250.0,
                  ),
                ),
              ),
              myForm(),
              myButton(),
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
      ),
    );
  }

  Widget myForm() {
    return new Form(
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
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
                validator: (value) =>
                    value.isEmpty ? "E-mail precisa ser preenchido" : null,
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
              validator: (value) =>
                  value.isEmpty ? "Password precisa ser preenchido" : null,
              onSaved: (value) => this._password = value,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FlatButton(
                child: new Text(
                  "Esqueceu a senha?",
                  style: TextStyle(color: Colors.black54, fontSize: 12.0),
                ),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("Teste"),
                        duration: new Duration(seconds: 3),
                      ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget myButton() {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.red.shade100,
        elevation: 5.0,
        child: MaterialButton(
          height: 42.0,
          onPressed: () {
            new Singleton().showLoadingDialog(context);
            validateAndSave();
          },
          color: Theme.of(context).primaryColor,
          child: new Text(
            "Log in",
            style: new TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
