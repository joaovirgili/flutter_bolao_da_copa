import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bolao/classes/gamebet.dart';

class Final extends StatefulWidget {
  @override
  _FinalState createState() => new _FinalState();
}

class _FinalState extends State<Final> {
  var matches;
  var _isLoading = true;
  final String urlMatches = "http://www.srgoool.com.br/call?ajax=get_chaves&id_ano_campeonato=434";

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
  _getMatches() async {
    print("Loading Finals...");
    final response = await http.get(urlMatches, );

    if (response.statusCode == 200) {
      print("Finals loaded");
      final map = json.decode(response.body);
      setState(() {
        matches = map["fases"][3];
        // print(matches["nome_fase"]);
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return new Material(
    //   child: _isLoading
    //       ? new Center(child: new CircularProgressIndicator())
    //       : new ListView.builder(
    //           itemCount: matches["jogos"].length,
    //           itemBuilder: (BuildContext context, int index) {
    //             return new GameBet(
    //               homeTeamName: matches["jogos"][index]["m_clube"],
    //               awayTeamName: matches["jogos"][index]["v_clube"],
    //               homeTeamId: matches["jogos"][index]["escudom"],
    //               awayTeamId: matches["jogos"][index]["escudov"],
    //               date: matches["jogos"][index]["datahora"],
    //               stage: "Semifinal"
    //             ).getGameBetaCard(context);
    //           },
    //         ),
    // );
    return new Center(child:new Text("OK"),);
  }

}