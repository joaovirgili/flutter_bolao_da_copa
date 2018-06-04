import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bolao/classes/gamebet.dart';
import '../../utils/singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/auth.dart';

class GroupStageMatches extends StatefulWidget {
  @override
  _GroupStageMatchesState createState() => new _GroupStageMatchesState();
}

class _GroupStageMatchesState extends State<GroupStageMatches> {
  var matches;
  bool _isLoading = true;
  Singleton sing;
  List<GameBetCard> gamesList;
  CollectionReference collectionReference;
  DocumentReference documentReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sing = new Singleton();
    new Auth().currentUser().then((user) {
      collectionReference = Firestore.instance
          .collection(user.uid)
          .document("jogos")
          .collection("grupos");
      _loadBets();
    });
    gamesList = new List<GameBetCard>();
    sing.update.addListener(sing.updateGroupsJson);
    sing.loading.addListener(_setLoading);
    // sing.saveGames.addListener(_saveGames);
    if (sing.isEliminationLoaded) {
      this._isLoading = false;
    } else {
      sing.updateGroupsJson();
      this._isLoading = true;
    }
    _getJson();
    
  }

  _loadBets() {
     collectionReference.document().get().then((snapshot) {
       if (snapshot.exists) {
         print(snapshot);
         print(snapshot.data);
       }
     });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sing.update.removeListener(sing.updateGroupsJson);
    sing.loading.removeListener(_setLoading);
    // sing.saveGames.removeListener(_saveGames);
    matches = null;
  }

  _setLoading() async {
    if (this.mounted) {
      if (sing.loading.value) {
        setState(() {
          this._isLoading = true;
        });
      } else {
        if (this.mounted) {
          this.matches = await sing.getGroupsJson();
          setState(() {
            this._isLoading = false;
          });
        }
      }
    }
  }

  Future _getJson() async {
    if (this.mounted) {
      this.matches = await sing.getGroupsJson();
      setState(() {
        this._isLoading = false;
      });
    }
  }

  // void _saveGames() {
  //   print("Start inserting...");
  //   List list = this.gamesList;
  //   print("Showing ${list.length} games.");

  //   for (var i = 0; i < list.length; i++) {
  //     GameBetCard gameBetCard = list.elementAt(i);
  //     if (gameBetCard != null) {
  //       gameBetCard.saveBets();
  //       if (gameBetCard.state.homeBet != null &&
  //           gameBetCard.state.homeBet != "") {
  //         Map<String, String> data = <String, String>{
  //           "casa": gameBetCard.state.homeBet,
  //           "fora": gameBetCard.state.awayBet
  //         };
  //         collectionReference
  //             .document(gameBetCard.id)
  //             .setData(data)
  //             .whenComplete(() {
  //           print("$i inserting finished ");
  //         }).catchError((e) {
  //           print(e);
  //         });
  //       }
  //     }
  //   }
  // }

  void _addGameBetToList(GameBetCard gameBetCard) {
    for (var i = 0; i < this.gamesList.length; i++) {
      if (this.gamesList.elementAt(i).id == gameBetCard.id) {
        return;
      }
    }
    this.gamesList.add(gameBetCard);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: _isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new ListView.builder(
              itemCount: matches != null ? matches["jogos"].length : 0,
              itemBuilder: (BuildContext context, int index) {
                GameBetCard actualGameBetCard = new GameBet(
                  homeTeamName: matches["jogos"][index]["m_clube"],
                  awayTeamName: matches["jogos"][index]["v_clube"],
                  homeTeamId: matches["jogos"][index]["id_clubem"],
                  awayTeamId: matches["jogos"][index]["id_clubev"],
                  date: matches["jogos"][index]["data"] +
                      " - " +
                      matches["jogos"][index]["hora"],
                  stage: Stage.groups,
                  groupName: matches["jogos"][index]["nome_grupo"],
                  scoreHomeBet: "",
                  scoreAwayBet: "",
                  scoreHome: matches["jogos"][index]["placarm_tn"],
                  scoreAway: matches["jogos"][index]["placarv_tn"],
                ).gameBetCard;
                _addGameBetToList(actualGameBetCard);
                return actualGameBetCard;
              },
            ),
    );
  }
}
