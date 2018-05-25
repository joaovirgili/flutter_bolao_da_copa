import 'package:flutter/material.dart';
import 'matches-group-stage.dart';
import 'matches-quarterFinals.dart';
import 'matches-round-of-sixteen.dart';
import 'matches-semi-and-final.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class Matches extends StatefulWidget {
  Matches({Key key, this.title}) : super(key: key);

  static const String routeName = "/Matches";
  final String title;

  @override
  _MatchesState createState() => new _MatchesState(title: title);
}

class _MatchesState extends State<Matches> with SingleTickerProviderStateMixin {
  _MatchesState({this.title});
  var _tabController;
  final String title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 4, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: new Text(title),
      ),
      body: new Center(
        child: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new GroupStageMatches(),
            new QuarterFinals(),
            new RoundOfSixteen(),
            new SemiAndFinal(),
          ],
        ),
      ),
      bottomNavigationBar: new Material(
        color: Colors.blueAccent,
        child: new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(
              text: "Grupos",
            ),
            new Tab(
              text: "Quartas de Final",
            ),
            new Tab(
              text: "Oitavas de Final",
            ),
            new Tab(
              text: "Semi e Final",
            )
          ],
        ),
      ),
    );
  }
}
