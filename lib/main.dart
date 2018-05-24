import 'package:flutter/material.dart';

import 'views/jogos.dart';
import 'views/user-info.dart';
import 'views/placar-geral.dart';

void main() => runApp(new Bolao());

class Bolao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => new _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 3, initialIndex: 2);
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
            new Jogos(),
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
            new Tab(
              icon: new Icon(Icons.verified_user),
              text: "Jogos",
            ),
          ],
        ),
      ),
      drawer: _myDrawer(context),
    );
  }

  Widget _myDrawer(BuildContext context) {
    return new Drawer(
      child: new Column(
        children: <Widget>[
          new DrawerHeader(
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      width: 50.0,
                      height: 50.0,
                      child: new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            "https://scontent.frec10-1.fna.fbcdn.net/v/t1.0-9/1610793_866622000015920_483298332116560229_n.jpg?_nc_cat=0&_nc_eui2=AeG6hU5O9bpn45wXmq1n9NAAANWLqqLyA7_2COR8Etat_yq17RL1swPzildCKkevNXeRtVfslx0u4q6axGzaAtNehwcfAV25AzvEnUwZurna0w&oh=cffd6dfcf18036fc763ee26370795752&oe=5BC4F882"),
                      ),
                    ),
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text("JP"),
                      ),
                    ),
                    new MaterialButton(
                        onPressed: null, child: new Text("Logout"))
                  ],
                ),
              ],
            ),
          ),
          new Expanded(
            child: new Column(
              children: <Widget>[
                new Text("Coisas"),
                new Text("Para"),
                new Text("Colocar"),
                new Text("Teste"),
                new Text("Teste"),
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: new Center(child: new Text("Close")),
            ),
          ),
        ],
      ),
    );
  }
}
