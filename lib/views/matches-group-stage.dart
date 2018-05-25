import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bolao/classes/gamebet.dart';


class GroupStageMatches extends StatefulWidget {
  @override
  _GroupStageMatchesState createState() => new _GroupStageMatchesState();

}

class _GroupStageMatchesState extends State<GroupStageMatches> {
  var matches;
  var _isLoading = true;

  _getMatches() async {
    final String urlMatches = "http://www.srgoool.com.br/call?ajax=get_classificacao2&id_fase=1796";
    final response = await http.get(urlMatches);
    print("Loading group stage...");

    if (response.statusCode == 200) {
      print("Group stage loaded.");
      final map = json.decode(response.body);
      setState(() {
        matches = map['jogos'];
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
    return new Material(
      child: _isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new ListView.builder(
              itemCount: matches.length,
              itemBuilder: (BuildContext context, int index) {
                return new GameBet(
                  homeTeamName: matches[index]["m_clube"],
                  awayTeamName: matches[index]["v_clube"],
                  homeTeamId: matches[index]["id_clubem"],
                  awayTeamId: matches[index]["id_clubev"],
                  date: matches[index]["data"] + " - " + matches[index]["hora"],
                  stage: matches[index]["nome_grupo"]
                ).getGameBetaCard(context);
              },
            ),
    );
  }
}
