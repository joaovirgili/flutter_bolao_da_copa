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
  bool _isLoading = true;
  Singleton sing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sing = new Singleton();
    sing.update.addListener(sing.updateGroupsJson);
    sing.loading.addListener(_setLoading);
    if (sing.isEliminationLoaded) {
      this._isLoading = false;
    } else {
      sing.updateGroupsJson();
      this._isLoading = true;
    }
    _getJson();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sing.update.addListener(null);
    sing.loading.addListener(null);
    matches = null;
  }

  _setLoading() async {
    if (this.mounted) {
      if (sing.loading.value) {
        setState(() {
          this._isLoading = true;
        });
      } else {
        if (this.mounted) {
          this.matches = await sing.getGroupsJson();
          setState(() {
            this._isLoading = false;
          });
        }
      }
    }
  }

  Future _getJson() async {
    if (this.mounted) {
      this.matches = await sing.getGroupsJson();
      setState(() {
        this._isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: _isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new ListView.builder(
              itemCount: matches != null ? matches["jogos"].length : 0,
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
