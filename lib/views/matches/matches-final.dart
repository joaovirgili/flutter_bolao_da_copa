import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../../utils/singleton.dart';

class Final extends StatefulWidget {
  @override
  _FinalState createState() => new _FinalState();
}

class _FinalState extends State<Final> {
  var matches;
  var _isLoading = true;
  var sing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sing = new Singleton();
    // sing.update.addListener(sing.updateEliminationJson());
    sing.loading.addListener(_setLoading);
    if (sing.isEliminationLoaded) {
      this._isLoading = false;
    } else {
      sing.updateEliminationJson();
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
    this._isLoading = false;
  }

  _setLoading() async {
    if (this.mounted) {
      if (sing.loading.value) {
        setState(() {
          this._isLoading = true;
        });
      } else {
        this.matches = await sing.getEliminationJson();
        setState(() {
          this._isLoading = false;
        });
      }
    }
  }

  Future _getJson() async {
    if (matches == null) {
      this.matches = await sing.getEliminationJson();
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
                itemCount: matches != null ? matches["fases"][3]["jogos"].length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return new GameBet(
                          homeTeamName: matches["fases"][3]["jogos"][index]
                              ["m_clube"],
                          awayTeamName: matches["fases"][3]["jogos"][index]
                              ["v_clube"],
                          homeTeamId: matches["fases"][3]["jogos"][index]
                              ["escudom"],
                          awayTeamId: matches["fases"][3]["jogos"][index]
                              ["escudov"],
                          date: matches["fases"][3]["jogos"][index]["datahora"],
                          stage: index == 0 ? "Final" : "Disputa de 3º lugar")
                      .getGameBetaCard(context);
                },
              ));
  }
}

// new Text(matches["fases"][0]["jogos"][0]["datahora"]),
