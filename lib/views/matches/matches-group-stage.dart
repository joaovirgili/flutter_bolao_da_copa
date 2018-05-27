import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../../utils/singleton.dart';


class GroupStageMatches extends StatefulWidget {
  @override
  _GroupStageMatchesState createState() => new _GroupStageMatchesState();
}

class _GroupStageMatchesState extends State<GroupStageMatches> {
  var matches;
  var _isLoading = true;

  Future _getJson() async {
    this.matches = await new Singleton().getGroupsJson();
    setState(() {
      this._isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJson();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    matches = null;
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: _isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new ListView.builder(
              itemCount: matches["jogos"].length,
              itemBuilder: (BuildContext context, int index) {
                return new GameBet(
                        homeTeamName: matches["jogos"][index]["m_clube"],
                        awayTeamName: matches["jogos"][index]["v_clube"],
                        homeTeamId: matches["jogos"][index]["id_clubem"],
                        awayTeamId: matches["jogos"][index]["id_clubev"],
                        date: matches["jogos"][index]["data"] +
                            " - " +
                            matches["jogos"][index]["hora"],
                        stage: matches["jogos"][index]["nome_grupo"])
                    .getGameBetaCard(context);
              },
            ),
    );
  }
}