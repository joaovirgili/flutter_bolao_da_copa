import 'package:flutter/material.dart';

import 'views/matches-geral.dart';
import 'views/user-info.dart';
import 'views/placar-geral.dart';

void main() => runApp(new Bolao());

class Bolao extends StatelessWidget {
  final appTitle = "Bolão da Copa";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      home: new MyHome(title: appTitle),
      theme: new ThemeData(),
      routes: <String, WidgetBuilder>{
        "/Matches": (BuildContext context) => new Matches(title: "Jogos"),
      },
    );
  }
}

class MyHome extends StatefulWidget {
  final String title;

  MyHome({Key key, this.title}) : super(key: key);

  @override
  _MyHomeState createState() => new _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Bolão do É Nóis!"),
      ),
      body: new Center(
        child: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new UserInfo(),
            new PlacarGeral(),
          ],
        ),
      ),
      bottomNavigationBar: new Material(
        color: Colors.blueAccent,
        child: new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.verified_user),
              text: "Minha conta",
            ),
            new Tab(
              icon: new Icon(Icons.verified_user),
              text: "Placar geral",
            ),
          ],
        ),
      ),
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
                    trailing: new Icon(Icons.monetization_on),
                  ),
                  new Divider(),
                ],
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: new RawMaterialButton(
                onPressed: () => print("logout user"),
                fillColor: Colors.redAccent,
                splashColor: Colors.red,
                child: new Text("Logout", style: new TextStyle(color: Colors.white),),
                shape: new StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
