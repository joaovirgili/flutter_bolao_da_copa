import 'package:flutter/material.dart';

import 'views/matches/matches-geral.dart';
import 'views/user-profile.dart';
import 'views/placar-geral.dart';
import 'views/login.dart';
import 'views/register.dart';

void main() => runApp(new Bolao());

class Bolao extends StatelessWidget {
  final appTitle = "Bolão da Copa";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      // home: new MyHome(title: appTitle),
      home: Login(),
      theme: new ThemeData(
        primaryColor: Color(0xFF0074B1),
        fontFamily: 'Nunito',
        
      ),
      routes: <String, WidgetBuilder>{
        "/Main": (BuildContext context) => new Main(title: appTitle),
        "/Matches": (BuildContext context) => new Matches(title: "Jogos"),
        "/UserProfile": (BuildContext context) => new UserProfile(title: "Minha conta"),
        "/Register": (BuildContext context) => new Register(title: "Cadastro"),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  static const String routeName = "/Main";
  final String title;

  @override
  _MainState createState() => new _MainState(title: title);
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  _MainState({this.title});
  final String title;
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
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
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text("JP"),
                        new Text("sr.joaovirgili@gmail.com")
                      ],
                    ),
                    new Text("32 pontos")
                  ],
                ),
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    "https://scontent.frec10-1.fna.fbcdn.net/v/t1.0-9/1610793_866622000015920_483298332116560229_n.jpg?_nc_cat=0&_nc_eui2=AeG6hU5O9bpn45wXmq1n9NAAANWLqqLyA7_2COR8Etat_yq17RL1swPzildCKkevNXeRtVfslx0u4q6axGzaAtNehwcfAV25AzvEnUwZurna0w&oh=cffd6dfcf18036fc763ee26370795752&oe=5BC4F882"),
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
                onPressed: () => print("logout user"),
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
