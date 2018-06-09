import 'package:flutter/material.dart';
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
  var bets;
  Singleton sing;
  CollectionReference collectionReference;
  List<Map<String, String>> _userBets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sing = new Singleton();
    _userBets = new List<Map<String, String>>();
    new Auth().currentUser().then((user) {
      collectionReference = Firestore.instance
          .collection(user.uid)
          .document("jogos")
          .collection("grupos");
      getBets(user.uid);
    });
    // sing.update.addListener(sing.updateGroupsJson);
    // sing.loading.addListener(_setLoading);
    // if (sing.isEliminationLoaded) {
    //   this._isLoading = false;
    // } else {
    //   sing.updateGroupsJson();
    //   this._isLoading = true;
    // }
    // _getJson();
  }

  getBets(id) async {
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
      _userBets.add(data);
      data = null;
    }
    setState(() {
        _isLoading = false;
      });
  }

  @override
  Widget build(BuildContext contex) {
    return _isLoading
        ? new Center(
            child: new CircularProgressIndicator(),
          )
        : new StreamBuilder(
            stream: Firestore.instance.collection("grupos").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return new Center(child: CircularProgressIndicator());
              return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var actualMatch = snapshot.data.documents[index];
                  final matchId = "${index.toString().padLeft(2, '0')}${actualMatch["id_clubem"]}${actualMatch["id_clubev"]}";
                  var homeBet, awayBet;
                  for (var i=0;i<_userBets.length;i++) {
                    if (_userBets.elementAt(i)["id"] == matchId) {
                      homeBet = _userBets.elementAt(i)["casa"];
                      awayBet = _userBets.elementAt(i)["fora"];
                    }
                  }
                  return new GameBet(
                          id: "${index.toString().padLeft(2, '0')}${actualMatch["id_clubem"]}${actualMatch["id_clubev"]}",
                          awayTeamId: actualMatch["id_clubev"],
                          awayTeamName: actualMatch["v_clube"],
                          homeTeamId: actualMatch["id_clubem"],
                          homeTeamName: actualMatch["m_clube"],
                          date: "${actualMatch["data"]} ${actualMatch["hora"]}",
                          finished: actualMatch["finalizado"],
                          stage: Stage.groups,
                          groupName: actualMatch["nome_grupo"],
                          scoreHomeBet: homeBet,
                          scoreAwayBet: awayBet,
                          scoreHome: actualMatch["placarm_tn"],
                          scoreAway: actualMatch["placarv_tn"],
                          )
                      .gameBetCard;
                },
              );
              // print(snapshot.data.documents.length);
              // return new Container();
            },
          );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // sing.update.removeListener(sing.updateGroupsJson);
    // sing.loading.removeListener(_setLoading);
    matches = null;
  }

  // _setLoading() async {
  //   if (this.mounted) {
  //     if (sing.loading.value) {
  //       setState(() {
  //         this._isLoading = true;
  //       });
  //     } else {
  //       if (this.mounted) {
  //         this.matches = await sing.getGroupsJson();
  //         setState(() {
  //           this._isLoading = false;
  //         });
  //       }
  //     }
  //   }
  // }

  // Future _getJson() async {
  //   if (this.mounted) {
  //     this.matches = await sing.getGroupsJson();
  //     setState(() {
  //       this._isLoading = false;
  //     });
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     return new Material(
//       child: _isLoading
//           ? new Center(child: new CircularProgressIndicator())
//           : new ListView.builder(
//             key: new PageStorageKey("Groups"),
//               itemCount: matches != null ? matches["jogos"].length : 0,
//               itemBuilder: (BuildContext context, int index) {
//                 GameBetCard actualGameBetCard = new GameBet(
//                   homeTeamName: matches["jogos"][index]["m_clube"],
//                   awayTeamName: matches["jogos"][index]["v_clube"],
//                   homeTeamId: matches["jogos"][index]["id_clubem"],
//                   awayTeamId: matches["jogos"][index]["id_clubev"],
//                   date: matches["jogos"][index]["data"] +
//                       " - " +
//                       matches["jogos"][index]["hora"],
//                   stage: Stage.groups,
//                   groupName: matches["jogos"][index]["nome_grupo"],
//                   scoreHomeBet: "",
//                   scoreAwayBet: "",
//                   scoreHome: matches["jogos"][index]["placarm_tn"],
//                   scoreAway: matches["jogos"][index]["placarv_tn"],
//                   finished: false
//                 ).gameBetCard;
//                 return actualGameBetCard;
//               },
//             ),
//     );
//   }
// }

}
