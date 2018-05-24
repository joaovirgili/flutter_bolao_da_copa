import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameBet {
  // final int matchday;
  final String date;

  final String homeTeamName;
  final String awayTeamName;

  final String homeTeamFlag;
  final String awayTeamFlag;

  // final int goalsHomeTeam;
  // final int goalsAwayTeam;

  // final String status;

  GameBet({
    @required this.homeTeamName,
    @required this.awayTeamName,
    @required this.homeTeamFlag,
    @required this.awayTeamFlag,
    @required this.date,
  });

  GameBetCard getGameBetaCard(BuildContext context) {
    return new GameBetCard(
      homeTeam: this.homeTeamName,
      awayTeam: this.awayTeamName,
      homeTeamFlag: this.homeTeamFlag,
      awayTeamFlag: this.awayTeamFlag,
      date: this.date,
    );
  }
}

class GameBetCard extends StatelessWidget {
  GameBetCard(
      {@required this.homeTeam,
      @required this.awayTeam,
      @required this.homeTeamFlag,
      @required this.awayTeamFlag,
      @required this.date});

  final String homeTeam;
  final String awayTeam;
  final String homeTeamFlag;
  final String awayTeamFlag;
  final String date;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: new Card(
        elevation: 5.0,
        child: new Column(
          children: <Widget>[
            // new Container(
            //   margin: const EdgeInsets.only(top: 20.0),
            //   child: new Text(this.date),
            // ),
            new ListTile(
              title: new Text("Grupo X"),
              subtitle: new Text(this.date),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 8.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        width: 80.0,
                        child: new Column(
                          children: <Widget>[
                            new Image.network(homeTeamFlag),
                            new Container(
                              height: 30.0,
                              child: new Text(
                                homeTeam,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _scoreTextField(),
                    ],
                  ),
                ),
                new Text("X"),
                new Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 8.0),
                  child: new Row(
                    children: <Widget>[
                      _scoreTextField(),
                      new Container(
                        width: 80.0,
                        child: new Column(
                          children: <Widget>[
                            new Image.network(awayTeamFlag),
                            new Container(
                              height: 30.0,
                              child: new Text(
                                awayTeam,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreTextField() {
    return new Container(
      width: 45.0,
      // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: new TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        ),
        inputFormatters: [new LengthLimitingTextInputFormatter(2)],
      ),
    );
  }
}
