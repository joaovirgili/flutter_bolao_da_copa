import 'package:flutter/material.dart';
import 'matches-group-stage.dart';
import 'matches-quarterFinals.dart';
import 'matches-round-of-sixteen.dart';
import 'matches-semi.dart';
import 'matches-final.dart';
import '../../utils/singleton.dart';

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
  Singleton sing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 5, initialIndex: 0);
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
      ),
      body: new Center(
        child: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new GroupStageMatches(),
            new RoundOfSixteen(),
            new QuarterFinals(),
            new SemiFinal(),
            new Final(),
          ],
        ),
      ),
      bottomNavigationBar: new Material(
        color: Theme.of(context).primaryColor,
        child: new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(text: "Grupos"),
            new Tab(text: "Oitavas"),
            new Tab(text: "Quartas"),
            new Tab(text: "Semi"),
            new Tab(text: "Final"),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
            if (sing.update.value) sing.update.value = false;
            else sing.update.value = true;
            // sing.updateData();
        }
      ),
    );
  }


}
