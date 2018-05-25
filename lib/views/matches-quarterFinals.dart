import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bolao/classes/gamebet.dart';

class QuarterFinals extends StatefulWidget {
  @override
  _QuarterFinalsState createState() => new _QuarterFinalsState();
}

class _QuarterFinalsState extends State<QuarterFinals> {
  var matches;
  var _isLoading = true;

  _getMatches() async {
    final String urlMatches = "http://www.srgoool.com.br/call?ajax=get_chaves&id_ano_campeonato=434";
    final response = await http.get(urlMatches);
    print("Loading QuarterFinals...");

    if (response.statusCode == 200) {
      print("Quarterfinals loaded");
      final map = json.decode(response.body);
      setState(() {
        matches = map["fases"][1]["jogos"];
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMatches();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: _isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new ListView.builder(
              itemCount: matches.length,
              itemBuilder: (BuildContext context, int index) {
                return new GameBet(
                  homeTeamName: matches[index]["m_clube"],
                  awayTeamName: matches[index]["v_clube"],
                  homeTeamId: matches[index]["escudom"],
                  awayTeamId: matches[index]["escudov"],
                  date: matches[index]["datahora"],
                  stage: "Quartas de Final"
                ).getGameBetaCard(context);
              },
            ),
    );
  }

}