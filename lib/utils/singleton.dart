import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  Future<Map<String, dynamic>> _groupsJson;
  Future<Map<String, dynamic>> _eliminationJson;
  ValueNotifier<bool> loading = new ValueNotifier<bool>(null);
  ValueNotifier<bool> update = new ValueNotifier<bool>(false);
  ValueNotifier<bool> saveGames = new ValueNotifier<bool>(false);
  bool isGroupsLoaded = false;
  bool isEliminationLoaded = false;
  List<Map<String, String>> _userBets = new List<Map<String, String>>();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal() {}

  getUsersBet() {
    return this._userBets;
  }

  clearUserBets() {
    this._userBets = new List<Map<String, String>>();
  }

  calculateUserScore() async {
    print("Calculando pontuações...");
    List<String> userIds = new List<String>();
    List<Map<String, dynamic>> games = new List<Map<String, dynamic>>();
    List<Map<String, dynamic>> usersBet = new List<Map<String, dynamic>>();
    Map<String, int> usersFinalScore = new Map<String, int>();

    //get users' id
    print("Buscando id dos usuarios...");
    await Firestore.instance.collection("users").getDocuments().then((docs) {
      print("Busca de id finalizada.");
      for (var i = 0; i < docs.documents.length; i++) {
        userIds.add(docs.documents[i].documentID);
      }
    });

    //get users bets
    print("Buscando aposta de cada usuario...");
    for (var i = 0; i < userIds.length; i++) {
      print("Buscando pela aposta do usuario $i...");
      await Firestore.instance
          .collection("users")
          .document(userIds.elementAt(i))
          .collection("grupos")
          .getDocuments()
          .then((bet) {
        print("Busca pela aposta do usuario $i finalizada.");
        for (var j = 0; j < bet.documents.length; j++) {
          Map<String, dynamic> data = new Map<String, dynamic>();
          data["game_id"] = bet.documents[j].documentID;
          data["user_id"] = userIds.elementAt(i);
          data["casa"] = bet.documents[j].data["casa"];
          data["fora"] = bet.documents[j].data["fora"];
          usersBet.add(data);
          data = null;
        }
      });
    }
    print("Busca aposta de cada usuario finalizada");

    print("Buscando pelo resultado dos jogos...");
    //get the matches in database
    await Firestore.instance.collection("grupos").getDocuments().then((doc) {
      print("Busca pelo resultado dos jogos finalizada");
      for (var i = 0; i < doc.documents.length; i++) {
        if (doc.documents[i].data["placarm_tn"] != -1) {
          Map<String, dynamic> data = new Map<String, dynamic>();
          data["id"] = doc.documents[i].documentID;
          data["placarm_tn"] = doc.documents[i].data["placarm_tn"];
          data["placarv_tn"] = doc.documents[i].data["placarv_tn"];
          games.add(data);
          data = null;
        }
      }
    });

    //calc score for each user
    for (int j = 0; j < usersBet.length; j++) {
      int betHome = int.parse(usersBet[j]["casa"]);
      int betAway = int.parse(usersBet[j]["fora"]);
      String gameId = usersBet[j]["game_id"];
      String userId = usersBet[j]["user_id"];
      for (int i = 0; i < games.length; i++) {
        int scoreHome = games[i]["placarm_tn"];
        int scoreAway = games[i]["placarv_tn"];
        if (games[i]["id"] == gameId) {
          int score = 0;
          if (betHome == scoreHome) score++;
          if (betAway == scoreAway) score++;

          if (scoreHome > scoreAway) { //home wins
            if (betHome > betAway) score += 2;
          }
          else if (scoreHome < scoreAway) { //home loses
            if (betHome < betAway) score += 2;
          } else { //draw
            if (betHome == betAway) score +=2;
          }

          if (score == 4) score++; 
          usersFinalScore[userId] = usersFinalScore[userId] == null
              ? score
              : usersFinalScore[userId] + score;
        }
      }
    }
    print(usersFinalScore);
    //update database
    for (var i = 0; i < usersFinalScore.keys.length; i++) {
      var userId = usersFinalScore.keys.elementAt(i);
      Map<String, int> data = new Map<String, int>();
      data["pontos"] = usersFinalScore[userId];
      Firestore.instance
          .collection("users")
          .document(usersFinalScore.keys.elementAt(i))
          .updateData(data);
    }
    print("Pontuações calculadas.");
  }

  Future getUsersBetFromDatabase(id) async {
    var teste = await Firestore.instance
        .collection("users")
        .document(id)
        .collection("grupos")
        .getDocuments();

    for (var i = 0; i < teste.documents.length; i++) {
      Map<String, String> data = new Map<String, String>();
      data["id"] = teste.documents[i].documentID;
      data["casa"] = teste.documents[i]["casa"];
      data["fora"] = teste.documents[i]["fora"];

      this._userBets.add(data);
      data = null;
    }
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => new AlertDialog(
              content: new Row(
                children: <Widget>[
                  new CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: new Text("Loading..."),
                  ),
                ],
              ),
            ));
  }

  updateGroupsJson() {
    _groupsJson = this.getJson(
        "http://www.srgoool.com.br/call?ajax=get_classificacao2&id_fase=1796");
    isGroupsLoaded = true;
  }

  updateEliminationJson() {
    _eliminationJson = this.getJson(
        "http://www.srgoool.com.br/call?ajax=get_chaves&id_ano_campeonato=434");
    isEliminationLoaded = true;
  }

  getGroupsJson() {
    return this._groupsJson;
  }

  getEliminationJson() {
    return this._eliminationJson;
  }

  Future<Map<String, dynamic>> getJson(url) async {
    this.loading.value = true;
    print("loading");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("loaded");
      var teste = json.decode(response.body);
      this.loading.value = false;
      return teste;
    } else {
      print("erro");
      return null;
    }
  }
}
