import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'utils/singleton.dart';
import 'views/matches/adminPage.dart';
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
        "/Main": (BuildContext context) => new Main(
              title: appTitle,
              auth: auth,
            ),
        "/Matches": (BuildContext context) =>
            new Matches(title: "Jogos", auth: auth),
        "/UserProfile": (BuildContext context) =>
            new UserProfile(title: "Minha conta", auth: auth),
        "/Register": (BuildContext context) =>
            new Register(title: "Cadastro", auth: auth),
        "/Login": (BuildContext context) => new Login(auth: auth),
        "/AddInfo": (BuildContext context) =>
            new AddUserInfo(title: "Completar cadastro", auth: auth),
        "/AdminPage": (BuildContext context) => new AdminPage(),
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
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final String title;
  final BaseAuth auth;
  String _userEmail = "", _userName = "", _userPhoto = "", _id = "";
  bool _admin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Auth().currentUser().then((user) {
      new Singleton().getUsersBetFromDatabase(user.uid);
      // new Singleton().calculateUserScore();
      Firestore.instance
          .collection("users")
          .document(user.uid)
          .get()
          .then((userDatabase) {
        setState(() {
          _id = user.uid;
          _admin = userDatabase.data["admin"];
          _userEmail = user.email;
          _userName = user.displayName == null ? "" : user.displayName;
          _userPhoto = user.photoUrl;
        });
      });
    });
  }

  _adminPage() {
    return new ListTile(
      title: new Text("Admin"),
      onTap: () => Navigator.popAndPushNamed(context, "/AdminPage"),
      trailing: new Image.asset(
        "assets/icons/icons-money-coins2.png",
        width: 20.0,
        height: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Atualizando pontuação..."),
                duration: new Duration(seconds: 3),
              ));
              new Singleton().calculateUserScore();
            }
          )
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
                          new Text(_userName),
                          new Text(_userEmail != null ? _userEmail : ""),
                        ],
                      ),
                    ),
                    // new Text("$_score pontos") //user scores
                    StreamBuilder(
                      stream: Firestore.instance.collection("users").document(_id).snapshots(),
                      builder:(context, snapshot) {
                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                        return new Text("${snapshot.data["pontos"].toString()} pontos");
                      } ,
                    ),
                  ],
                ),
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: _userPhoto == null
                    ? new AssetImage("assets/icons/icons-user2.png")
                    : new NetworkImage(_userPhoto),
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
                  ),
                  new Divider(),
                  this._admin !=null ? _adminPage() : Container(),
                ],
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: new RawMaterialButton(
                onPressed: () {
                  new Auth().signOut();
                  new Singleton().clearUserBets();
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
