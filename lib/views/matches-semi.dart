import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bolao/classes/gamebet.dart';
import 'package:flutter_bolao/utils/singleton.dart';

class SemiFinal extends StatefulWidget {
  @override
  _SemiFinalState createState() => new _SemiFinalState();
}

class _SemiFinalState extends State<SemiFinal> {
  var matches;
  var _isLoading = true;

  // _getMatches() async {
  //   final String urlMatches = "http://www.srgoool.com.br/call?ajax=get_chaves&id_ano_campeonato=434";
  //   print("Loading Semifinals...");
  //   final response = await http.get(urlMatches);

  //   if (response.statusCode == 200) {
  //     print("Semifinals loaded");
  //     final map = json.decode(response.body);
  //     setState(() {
  //       matches = map["fases"][2]["jogos"];
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // matches = new Singleton().eliminationJson;
    // print(matches);
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
    // return new Material(
    //   child: _isLoading
    //       ? new Center(child: new CircularProgressIndicator())
    //       : new ListView.builder(
    //           itemCount: matches.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             return new GameBet(
    //               homeTeamName: matches[index]["m_clube"],
    //               awayTeamName: matches[index]["v_clube"],
    //               homeTeamId: matches[index]["escudom"],
    //               awayTeamId: matches[index]["escudov"],
    //               date: matches[index]["datahora"],
    //               stage: "Semifinal"
    //             ).getGameBetaCard(context);
    //           },
    //         ),
    // );
    return new Center(child: new Text("SemiFinal"));
  }

}