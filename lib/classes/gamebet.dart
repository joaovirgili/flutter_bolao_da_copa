import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/auth.dart';

enum Stage { groups, roundOfSixteen, quarterFinals, semiFinals, third, finals }

class GameBet {
  String id;
  String date;
  Stage stage;

  String homeTeamName;
  String awayTeamName;

  String homeTeamId;
  String awayTeamId;

  // final int scoreHomeTeam;
  // final int scoreAwayTeam;

  String scoreHomeBet, scoreAwayBet;
  String scoreHome, scoreAway;

  GameBetCard gameBetCard;
  String groupName;

  // final String status;

  GameBet(
      {@required homeTeamName,
      @required awayTeamName,
      @required homeTeamId,
      @required awayTeamId,
      @required date,
      @required stage,
      @required scoreHome,
      @required scoreAway,
      scoreHomeBet,
      scoreAwayBet,
      groupName}) {
    this.id = "$homeTeamId$awayTeamId";
    this.homeTeamName = homeTeamName;
    this.awayTeamName = awayTeamName;
    this.homeTeamId = homeTeamId;
    this.awayTeamId = awayTeamId;
    this.date = date;
    this.stage = stage;
    this.scoreHome = scoreHome;
    this.scoreAway = scoreAway;
    this.groupName = groupName;
    scoreHomeBet != null ? this.scoreHomeBet = scoreHomeBet : null;
    scoreAwayBet != null ? this.scoreAwayBet = scoreAwayBet : null;
    _generateGameBetCard();
  }
  _generateGameBetCard() {
    this.gameBetCard = new GameBetCard(
        id: this.id,
        homeTeam: this.homeTeamName != null ? this.homeTeamName : "TBD",
        awayTeam: this.awayTeamName != null ? this.awayTeamName : "TBD",
        homeTeamImage:
            homeTeamId != null ? "assets/$homeTeamId.png" : "assets/666.png",
        awayTeamImage:
            awayTeamId != null ? "assets/$awayTeamId.png" : "assets/666.png",
        date: this.date,
        stage: this.stage,
        initialHomeBet: this.scoreHomeBet != null ? this.scoreHomeBet : "",
        initialAwayBet: this.scoreAwayBet != null ? this.scoreAwayBet : "",
        scoreHome: this.scoreHome,
        scoreAway: this.scoreAway,
        groupName: this.groupName,
        homeTeamId: this.homeTeamId,
        awayTeamId: this.awayTeamId);
  }
}

class GameBetCard extends StatefulWidget {
  String id;
  String homeTeam;
  String awayTeam;
  String homeTeamImage;
  String awayTeamImage;
  String date;
  Stage stage;
  String homeBet;
  String awayBet;
  String initialHomeBet;
  String initialAwayBet;
  String scoreHome;
  String scoreAway;
  String groupName;
  String homeTeamId;
  String awayTeamId;
  GameBetCardState state;

  GameBetCard(
      {@required id,
      @required homeTeam,
      @required awayTeam,
      @required homeTeamImage,
      @required awayTeamImage,
      @required date,
      @required stage,
      @required scoreHome,
      @required scoreAway,
      @required homeTeamId,
      @required awayTeamId,
      initialHomeBet,
      initialAwayBet,
      groupName}) {
    this.id = id;
    this.homeTeam = homeTeam;
    this.awayTeam = awayTeam;
    this.homeTeamImage = homeTeamImage;
    this.awayTeamImage = awayTeamImage;
    this.date = date;
    this.stage = stage;
    this.scoreHome = scoreHome;
    this.scoreAway = scoreAway;
    this.groupName = groupName;
    this.homeTeamId = homeTeamId;
    this.awayTeamId = awayTeamId;
    initialHomeBet != null ? this.initialHomeBet = initialHomeBet : null;
    initialAwayBet != null ? this.initialAwayBet = initialAwayBet : null;
  }

  void saveBets() {
    this.state.saveBets();
    // print(this.homeBet);
  }

  @override
  GameBetCardState createState() {
    this.state = GameBetCardState();
    return this.state;
  }
}

enum SaveLoading { saved, notSaved, saving }

class GameBetCardState extends State<GameBetCard> {
  String homeBet, awayBet;
  String homeBetFromDatabase, awayBetFromDatabase;
  bool betFromDatabase = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  SaveLoading _saveLoading = SaveLoading.notSaved;
  CollectionReference collectionReference;
  DocumentReference documentReference;
  String collection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch (widget.stage) {
      case Stage.groups:
        collection = "grupos";
        break;
      case Stage.roundOfSixteen:
        collection = "oitavas";
        break;
      case Stage.quarterFinals:
        collection = "quartas";
        break;
      case Stage.semiFinals:
        collection = "semi";
        break;
      case Stage.finals:
        collection = "final";
        break;
      case Stage.third:
        collection = "terceiro-lugar";
        break;
    }
    new Auth().currentUser().then((user) {
      collectionReference = Firestore.instance
          .collection(user.uid)
          .document("jogos")
          .collection(collection);
      Firestore.instance
          .collection(user.uid)
          .document("jogos")
          .collection("grupos")
          .document("${widget.homeTeamId}${widget.awayTeamId}")
          .get()
          .then((dataSnapshot) {
        if (dataSnapshot.exists && dataSnapshot.data != null) {
          setState(() {
            this.betFromDatabase = true;
            this.homeBetFromDatabase = dataSnapshot.data["casa"];
            this.awayBetFromDatabase = dataSnapshot.data["fora"];
            print(homeBetFromDatabase);
          });
        } else {
          print("Sem dados.");
          setState(() {
            this.betFromDatabase = true;
          });
        }
      });
    });
  }

  void saveBets() {
    if (_formKey.currentState != null) _formKey.currentState.save();
  }

  saveCard() {
    if (_formKey.currentState != null) {
      _formKey.currentState.save();

      if (this.homeBet != "" && this.awayBet != "") {
        setState(() {
          _saveLoading = SaveLoading.saving;
        });
        Map<String, String> data = <String, String>{
          "casa": this.homeBet,
          "fora": this.awayBet
        };
        collectionReference.document(widget.id).setData(data).whenComplete(() {
          setState(() {
            _saveLoading = SaveLoading.saved;
          });
          print("Inserido no banco");
        }).catchError((e) {
          print(e);
          setState(() {
            _saveLoading = SaveLoading.notSaved;
          });
        });
      } else {
        //todo show error
      }
    }
  }

  Widget _cardTrailing() {
    switch (_saveLoading) {
      case SaveLoading.saving:
        return new CircularProgressIndicator();
        break;
      case SaveLoading.notSaved:
        return new IconButton(
          icon: new Icon(Icons.save),
          onPressed: saveCard,
        );
        break;
      case SaveLoading.saved:
        return new Row(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.only(left: 4.0),
                child: new Text("Saved")),
            new IconButton(
              icon: new Icon(Icons.check),
              onPressed: saveCard,
            ),
          ],
        );
    }
    return Container();
  }

  Text _stageText(stage) {
    String text;
    switch (stage) {
      case Stage.groups:
        text = widget.groupName;
        break;
      case Stage.roundOfSixteen:
        text = "Oitavas de Final";
        break;
      case Stage.quarterFinals:
        text = "Quartas de Final";
        break;
      case Stage.semiFinals:
        text = "Semi Final";
        break;
      case Stage.third:
        text = "Terceiro lugar";
        break;
      case Stage.finals:
        text = "Final";
        break;
    }
    return new Text(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: new Card(
            elevation: 5.0,
            child: new Column(children: <Widget>[
              new Container(
                height: 60.0,
                child: new ListTile(
                  title: _stageText(widget.stage),
                  subtitle: new Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: new Text(this.widget.date)),
                  trailing: _cardTrailing(),
                ),
              ),
              new Divider(height: 5.0),
              new Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            width: 80.0,
                            child: new Column(children: <Widget>[
                              new Image.asset(
                                widget.homeTeamImage,
                                height: 64.0,
                                width: 64.0,
                              ),
                              new Container(
                                  height: 30.0,
                                  child: new Text(
                                    widget.homeTeam,
                                    textAlign: TextAlign.center,
                                  ))
                            ])),
                        new Container(
                            child: new Form(
                                key: _formKey,
                                child: new Column(children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      this.betFromDatabase
                                          ? _homeFormField(homeBetFromDatabase)
                                          : CircularProgressIndicator(),
                                      new Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: new Text("X")),
                                      this.betFromDatabase
                                          ? _awayFormField(awayBetFromDatabase)
                                          : CircularProgressIndicator(),
                                    ],
                                  ),
                                  new Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: new Column(children: <Widget>[
                                        new Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: new Text("Resultado:"),
                                        ),
                                        new Text(
                                            "${widget.scoreHome} - ${widget.scoreAway}")
                                      ]))
                                ]))),
                        new Container(
                            width: 80.0,
                            child: new Column(children: <Widget>[
                              new Image.asset(
                                widget.awayTeamImage,
                                height: 64.0,
                                width: 64.0,
                              ),
                              new Container(
                                  height: 30.0,
                                  child: new Text(
                                    widget.awayTeam,
                                    textAlign: TextAlign.center,
                                  ))
                            ]))
                      ]))
            ])));
  }

  Widget _homeFormField(initialValue) {
    return new Container(
      width: 45.0,
      // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: new TextFormField(
        enabled: widget.stage == Stage.groups ? true : false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        ),
        inputFormatters: [new LengthLimitingTextInputFormatter(2)],
        onSaved: (value) {
          this.homeBet = value;
        },
        initialValue: initialValue,
      ),
    );
  }

  Widget _awayFormField(initialValue) {
    return new Container(
      width: 45.0,
      // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: new TextFormField(
        enabled: widget.stage == Stage.groups ? true : false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        ),
        inputFormatters: [new LengthLimitingTextInputFormatter(2)],
        onSaved: (value) => this.awayBet = value,
        initialValue: initialValue,
      ),
    );
  }
}
