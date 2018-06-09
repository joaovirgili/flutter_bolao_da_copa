import 'package:flutter/material.dart';
import 'matches-group-stage.dart';
// import 'matches-quarterFinals.dart';
// import 'matches-round-of-sixteen.dart';
// import 'matches-semi.dart';
// import 'matches-final.dart';
import '../../utils/singleton.dart';
import '../../utils/auth.dart';

class Matches extends StatefulWidget {
  Matches({Key key, this.title, this.auth}) : super(key: key);

  static const String routeName = "/Matches";
  final String title;
  final BaseAuth auth;

  @override
  _MatchesState createState() => new _MatchesState(title: title, auth:auth);
}

class _MatchesState extends State<Matches> with SingleTickerProviderStateMixin {
  _MatchesState({this.title, this.auth});
  final String title;
  final BaseAuth auth;

  // var _tabController;
  Singleton sing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _tabController = new TabCosntroller(vsync: this, length: 5, initialIndex: 0);
    sing = new Singleton();
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
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              _callUpdate();
            }
          )
        ],
      ),
      body: new GroupStageMatches(),
      // body: new Center(
      //   child: new TabBarView(
      //     controller: _tabController,
      //     children: <Widget>[
      //       new GroupStageMatches(),
      //       new RoundOfSixteen(),
      //       new QuarterFinals(),
      //       new SemiFinal(),
      //       new Final(),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: new Material(
      //   color: Theme.of(context).primaryColor,
      //   child: new TabBar(
      //     controller: _tabController,
      //     tabs: <Widget>[
      //       new Tab(text: "Grupos"),
            // new Tab(text: "Oitavas"),
            // new Tab(text: "Quartas"),
            // new Tab(text: "Semi"),
            // new Tab(text: "Final"),
      //     ],
      //   ),
      // ),
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //       _callSaveGames();
      //   },
      //   child: new Icon(Icons.save),
      // ),
    );
  }

  void _callUpdate() {
    if (sing.update.value) sing.update.value = false;
    else sing.update.value = true;
  }

  // void _callSaveGames() {
  //   if (sing.saveGames.value) sing.saveGames.value = false;
  //   else sing.saveGames.value = true;
  // }


}
