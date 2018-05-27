import 'package:flutter/material.dart';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../../utils/singleton.dart';

class Final extends StatefulWidget {
  @override
  _FinalState createState() => new _FinalState();
}

class _FinalState extends State<Final> {
  var matches = new Map();
  var _isLoading = true;
  var sing;

  _getJson() async {
    print("getting finals matches");
    var jsonLoaded = await sing.getEliminationJson();
    setState(() {
      this.matches = jsonLoaded;
      this._isLoading= false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sing = new Singleton();
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
    // TODO: implement build
    return new Material(
      child: _isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new ListView.builder(
              itemCount: matches["fases"][3]["jogos"].length,
              itemBuilder: (BuildContext context, int index) {
                return new GameBet(
                  homeTeamName: matches["fases"][3]["jogos"][index]["m_clube"],
                  awayTeamName: matches["fases"][3]["jogos"][index]["v_clube"],
                  homeTeamId: matches["fases"][3]["jogos"][index]["escudom"],
                  awayTeamId: matches["fases"][3]["jogos"][index]["escudov"],
                  date: matches["fases"][3]["jogos"][index]["datahora"],
                  stage: index == 0 ? "Final" : "Disputa de 3º lugar"
                ).getGameBetaCard(context);
              },
            )
    );
  }

}

// new Text(matches["fases"][0]["jogos"][0]["datahora"]),




