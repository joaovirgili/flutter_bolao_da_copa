import 'package:flutter/material.dart';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../utils/singleton.dart';
import 'dart:async';

class RoundOfSixteen extends StatefulWidget {
  @override
  _RoundOfSixteenState createState() => new _RoundOfSixteenState();
}

class _RoundOfSixteenState extends State<RoundOfSixteen> {
  var matches;
  var _isLoading = true;

  Future _getMatches() async {
    this.matches = await new Singleton().getEliminationJson();
    print(matches.length);
    setState(() {
      this._isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMatches();
  }

  @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      matches = null;
    }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: _isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new ListView.builder(
              itemCount: matches[0].length,
              itemBuilder: (BuildContext context, int index) {
                return new GameBet(
                  homeTeamName: matches[0][index]["m_clube"],
                  awayTeamName: matches[0][index]["v_clube"],
                  homeTeamId: matches[0][index]["escudom"],
                  awayTeamId: matches[0][index]["escudov"],
                  date: matches[0][index]["datahora"],
                  stage: "Oitavas de Final"
                ).getGameBetaCard(context);
              },
            ),
    );
  }

}