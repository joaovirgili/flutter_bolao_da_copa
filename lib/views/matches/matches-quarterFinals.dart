import 'package:flutter/material.dart';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../../utils/singleton.dart';

class QuarterFinals extends StatefulWidget {
  @override
  _QuarterFinalsState createState() => new _QuarterFinalsState();
}

class _QuarterFinalsState extends State<QuarterFinals> {
  var matches = new Map();
  var _isLoading = true;
  var sing;

  _getJson() async {
    print("getting quarter finals matches");
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
              itemCount: matches["fases"][1]["jogos"].length,
              itemBuilder: (BuildContext context, int index) {
                return new GameBet(
                  homeTeamName: matches["fases"][1]["jogos"][index]["m_clube"],
                  awayTeamName: matches["fases"][1]["jogos"][index]["v_clube"],
                  homeTeamId: matches["fases"][1]["jogos"][index]["escudom"],
                  awayTeamId: matches["fases"][1]["jogos"][index]["escudov"],
                  date: matches["fases"][1]["jogos"][index]["datahora"],
                  stage: "Quartas de final"
                ).getGameBetaCard(context);
              },
            )
    );
  }

}



