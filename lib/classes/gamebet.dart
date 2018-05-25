import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameBet {
  // final int matchday;
  final String date;
  final String stage;

  final String homeTeamName;
  final String awayTeamName;

  final String homeTeamId;
  final String awayTeamId;

  // final int goalsHomeTeam;
  // final int goalsAwayTeam;

  // final String status;

  GameBet({
    @required this.homeTeamName,
    @required this.awayTeamName,
    @required this.homeTeamId,
    @required this.awayTeamId,
    @required this.date,
    @required this.stage,
  });

  GameBetCard getGameBetaCard(BuildContext context) {
    return new GameBetCard(
      homeTeam: this.homeTeamName,
      awayTeam: this.awayTeamName,
      homeTeamImage: "assets/" + homeTeamId + ".png",
      awayTeamImage: "assets/" + awayTeamId + ".png",
      date: this.date,
      stage: this.stage,
    );
  }
}

class GameBetCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeTeamImage;
  final String awayTeamImage;
  final String date;
  final String stage;

  GameBetCard(
      {@required this.homeTeam,
      @required this.awayTeam,
      @required this.homeTeamImage,
      @required this.awayTeamImage,
      @required this.date,
      @required this.stage});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: new Card(
        elevation: 5.0,
        child: new Column(
          children: <Widget>[
            new Container(
              height: 60.0,
              child: new ListTile(
                title: new Text(stage),
                subtitle: new Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: new Text(this.date)),
              ),
            ),
            new Divider(
              height: 5.0,
            ),
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 80.0,
                    child: new Column(
                      children: <Widget>[
                        new Image.asset(homeTeamImage),
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
                  new Container(
                    height: 50.0,
                    margin: const EdgeInsets.only(bottom: 30.0),
                    child: new Row(
                      children: <Widget>[
                        _scoreTextField(),
                        new Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: new Text("X")),
                        _scoreTextField(),
                      ],
                    ),
                  ),
                  new Container(
                    width: 80.0,
                    child: new Column(
                      children: <Widget>[
                        new Image.asset(awayTeamImage),
                        new Container(
                          height: 30.0,
                          child: new Text(
                            awayTeam,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
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
