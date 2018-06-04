import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../../utils/singleton.dart';

class RoundOfSixteen extends StatefulWidget {
  @override
  _RoundOfSixteenState createState() => new _RoundOfSixteenState();
}

class _RoundOfSixteenState extends State<RoundOfSixteen> {
  // var matches = new Map();
  // var _isLoading = true;
  // var sing;

  // _getJson() async {
  //   print("getmatches round of sixteen");
  //   var jsonLoaded = await sing.getEliminationJson();
  //   setState(() {
  //     this.matches = jsonLoaded;
  //     this._isLoading= false;
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   sing = new Singleton();
  //   _getJson();
  // }

  // @override
  //   void dispose() {
  //     // TODO: implement dispose
  //     super.dispose();
  //     matches = null;
  //   }

  var matches;
  bool _isLoading = true;
  Singleton sing;

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
    if (this.mounted) {
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
                itemCount: matches!= null? matches["fases"][0]["jogos"].length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return new GameBet(
                          homeTeamName: matches["fases"][0]["jogos"][index]
                              ["m_clube"],
                          awayTeamName: matches["fases"][0]["jogos"][index]
                              ["v_clube"],
                          homeTeamId: matches["fases"][0]["jogos"][index]
                              ["escudom"],
                          awayTeamId: matches["fases"][0]["jogos"][index]
                              ["escudov"],
                          date: matches["fases"][0]["jogos"][index]["datahora"],
                          stage: Stage.roundOfSixteen,
                          scoreHome: matches["fases"][0]["jogos"][index]["placarm_tn"],
                          scoreAway: matches["fases"][0]["jogos"][index]["placarv_tn"],
                          scoreHomeBet: "",
                          scoreAwayBet: "",
                  ).gameBetCard;
                },
              ));
  }
}
