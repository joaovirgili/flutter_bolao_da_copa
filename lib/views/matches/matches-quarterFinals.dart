import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../../utils/singleton.dart';

class QuarterFinals extends StatefulWidget {
  @override
  _QuarterFinalsState createState() => new _QuarterFinalsState();
}

class _QuarterFinalsState extends State<QuarterFinals> {
  var matches;
  var _isLoading = true;
  Singleton sing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sing = new Singleton();
    sing.update.addListener(sing.updateEliminationJson());
    sing.loading.addListener(_setLoading);
    sing.updateEliminationJson();
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
    if (sing.loading.value && this.mounted) {
      setState(() {
        this._isLoading = true;
      });
    } else {
      this.matches = await sing.getEliminationJson();
      if (this.mounted) {
        setState(() {
        this._isLoading = false;
      });
      }
    }
  }

  Future _getJson() async {
    this.matches = await sing.getEliminationJson();
    if (matches == null){
        setState(() {
        this._isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
        child: _isLoading
            ? new Center(child: new CircularProgressIndicator())
            : new ListView.builder(
                itemCount: matches["fases"][1]["jogos"].length,
                itemBuilder: (BuildContext context, int index) {
                  return new GameBet(
                          homeTeamName: matches["fases"][1]["jogos"][index]
                              ["m_clube"],
                          awayTeamName: matches["fases"][1]["jogos"][index]
                              ["v_clube"],
                          homeTeamId: matches["fases"][1]["jogos"][index]
                              ["escudom"],
                          awayTeamId: matches["fases"][1]["jogos"][index]
                              ["escudov"],
                          date: matches["fases"][1]["jogos"][index]["datahora"],
                          stage: "Quartas de final")
                      .getGameBetaCard(context);
                },
              ));
  }
}
