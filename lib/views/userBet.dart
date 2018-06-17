import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserBet extends StatefulWidget {
  UserBet(this.userId, this.title);
  String userId;
  String title;
  static const String routeName = "/UserBet";

  @override
  _UserBetState createState() => _UserBetState(this.userId, this.title);
}

class _UserBetState extends State<UserBet> {
  _UserBetState(this.userId, this.title);
  String userId;
  String title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: _allBets(),
    );
  }

  Widget _allBets() {
    return new Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("users")
            .document(this.userId)
            .collection("grupos")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
          return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              var bet = snapshot.data.documents[index];
              return betCard(bet["casa"], bet["fora"], bet.documentID);
            },
          );
        },
      ),
    );
  }

  Widget betCard(casa, fora, betID) {
    return new StreamBuilder(
      stream:
          Firestore.instance.collection("grupos").document(betID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(
            child: new CircularProgressIndicator(),
          );
        var homeName = snapshot.data["m_clube"];
        var awayName = snapshot.data["v_clube"];
        var homeScore = snapshot.data["placarm_tn"];
        var awayScore = snapshot.data["placarv_tn"];
        var homeID = snapshot.data["id_clubem"];
        var awayID = snapshot.data["id_clubev"];
        var groupName = snapshot.data["nome_grupo"];
        var dateTime = "${snapshot.data["data"]} - ${snapshot.data["hora"]}";


        return new Card(
          elevation: 5.0,
          margin: const EdgeInsets.all(10.0),
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  height: 40.0,
                  child: new ListTile(
                    title: new Text(groupName),
                    subtitle: new Text(dateTime),
                    trailing: _headerRow(),
                  ),
                ),
                new Divider(),
                _contentRow(homeID, homeName, awayID, awayName, homeScore, awayScore, casa, fora),

              ],
            ),
          ),
        );
      },
    );
  }

  _headerRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Column(children: <Widget>[
          new Container(width: 75.0, child: new Text("Resultado", textAlign: TextAlign.center,),)
        ],),
        new Column(children: <Widget>[
          new Container(width: 75.0, child: new Text("Aposta", textAlign: TextAlign.center,))
        ],),

      ],
    );
  }

  _contentRow(homeId, homeName, awayId, awayName, homeScore, awayScore, homeBet, awayBet) {
    homeScore = homeScore != -1 ? homeScore : "TBD";
    awayScore = awayScore != -1 ? awayScore : "TBD";
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Container(
          width: 160.0,
          child: new Column(children: <Widget>[
            _teamRow(homeId, homeName),
            _teamRow(awayId, awayName),
          ],),
        ),
        new Column(
          children: <Widget>[
            new Container(height: 30.0, width: 70.0, child: new Text(homeScore.toString(), textAlign: TextAlign.center,)),
            new Container(height: 30.0, width: 70.0, child: new Text(awayScore.toString(), textAlign: TextAlign.center,))
        ],),
        new Column(children: <Widget>[
          new Container(height: 30.0, width: 70.0, child: new Text(homeBet.toString(), textAlign: TextAlign.center,)),
          new Container(height: 30.0, width: 70.0, child: new Text(awayBet.toString(), textAlign: TextAlign.center,))
        ],),
      ],
    );
  }

  _teamRow(teamId, teamName) {
    return new Row(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(right: 5.0),
          width: 36.0,
          height: 36.0,
          child: new Image.asset("assets/$teamId.png"),
        ),
        new Text(teamName)
      ],
    );
  }
}
