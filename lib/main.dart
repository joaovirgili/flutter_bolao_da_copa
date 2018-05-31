import 'package:flutter/material.dart';

import 'views/matches/matches-geral.dart';
import 'views/my-account.dart';
import 'views/placar-geral.dart';
import 'views/login.dart';
import 'views/register.dart';
import 'views/add-user-info.dart';

import 'utils/auth.dart';

import 'classes/root.dart';

void main() => runApp(new Bolao());

class Bolao extends StatelessWidget {
  final appTitle = "Bolão da Copa";
  final BaseAuth auth = new Auth();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      home: RootPage(
        auth: auth,
      ),
      theme: new ThemeData(
        primaryColor: Color(0xFF0074B1),
        fontFamily: 'Nunito',
      ),
      routes: <String, WidgetBuilder>{
        "/Main": (BuildContext context) => new Main(title: appTitle, auth: auth,),
        "/Matches": (BuildContext context) => new Matches(title: "Jogos", auth:auth),
        "/UserProfile": (BuildContext context) =>
            new UserProfile(title: "Minha conta", auth:auth),
        "/Register": (BuildContext context) => new Register(title: "Cadastro", auth:auth),
        "/Login": (BuildContext context) => new Login(auth: auth,),
        "/AddInfo": (BuildContext context) => new AddUserInfo(title: "Completar cadastro", auth: auth),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title, this.auth}) : super(key: key);

  static const String routeName = "/Main";
  final String title;
  final BaseAuth auth;

  @override
  _MainState createState() => new _MainState(title: title, auth: this.auth);
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  _MainState({this.title, this.auth});
  final String title;
  final BaseAuth auth;
  String _userEmail, _userName, _userPhoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Auth().currentUser().then((user) {
      setState(() {
        _userEmail = user.email;
        _userName = user.displayName == null ? "" : user.displayName;
        _userPhoto = user.photoUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              new Auth().signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/Login", (v) => false);
            },
            child: new Text(
              "Logout",
              style: new TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: new PlacarGeral(),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Container(
                padding: const EdgeInsets.only(right: 20.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(_userName), //username
                          new Text(_userEmail != null ? _userEmail : ""),
                        ],
                      ),
                    ),
                    new Text("32 pontos") //user scores
                  ],
                ),
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: _userPhoto == null ? new AssetImage("assets/icons/icons-user2.png") : new NetworkImage(_userPhoto),
                // backgroundImage: new AssetImage("assets/icons/icons-user2.png"),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              accountEmail: null,
            ),
            new Expanded(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text("Mnhas apostas"),
                    onTap: () => Navigator.popAndPushNamed(context, "/Matches"),
                    trailing: new Image.asset(
                      "assets/icons/icons-money-coins2.png",
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                  new Divider(),
                  new ListTile(
                    title: new Text("Resultados"),
                    onTap: () => null,
                    trailing: new Image.asset(
                      "assets/icons/icons-stadium.png",
                      height: 20.0,
                      width: 20.0,
                    ),
                  ),
                  new Divider(),
                  new ListTile(
                    title: new Text("Minha conta"),
                    onTap: () =>
                        Navigator.popAndPushNamed(context, "/UserProfile"),
                    trailing: new Image.asset(
                      "assets/icons/icons-soccer-player.png",
                      width: 20.0,
                      height: 20.0,
                    ),
                  )
                ],
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: new RawMaterialButton(
                onPressed: () {
                  new Auth().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/Login", (v) => false);
                },
                fillColor: Colors.redAccent,
                splashColor: Colors.red,
                child: new Text(
                  "Logout",
                  style: new TextStyle(color: Colors.white),
                ),
                shape: new StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
