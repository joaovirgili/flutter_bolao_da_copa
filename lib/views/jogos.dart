import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bolao/classes/gamebet.dart';


class Jogos extends StatefulWidget {
  @override
  _JogosState createState() => new _JogosState();
}

class _JogosState extends State<Jogos> {
  var matches;
  var _isLoading = true;

  _getMatches() async {
    final String urlMatches = "http://www.srgoool.com.br/call?ajax=get_classificacao2&id_fase=1796";
    final response = await http.get(urlMatches);
    print("Loading matches...");

    if (response.statusCode == 200) {
      print("Ok");
      final map = json.decode(response.body);
      setState(() {
        matches = map['jogos'];
        print(matches[0]["m_clube"]);
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
                  homeTeamFlag: "http://www.countryflags.io/BR/shiny/64.png",
                  awayTeamFlag: "http://www.countryflags.io/EG/shiny/64.png",
                  date: matches[index]["data"] + " - " + matches[index]["hora"],
                ).getGameBetaCard(context);
              },
            ),
    );
  }
}
