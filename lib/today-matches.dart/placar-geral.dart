import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacarGeral extends StatefulWidget {
  @override
  PlacarGeralState createState() {
    return new PlacarGeralState();
  }
}

class PlacarGeralState extends State<PlacarGeral> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        children: <Widget>[
          new Text("Placar geral"),
          new Expanded(
            child: new Container(
              child: _myList()),
          ),
        ],
      ),
    );
  }

  Widget _myList() {
    return new ListView.builder(
      // padding: const EdgeInsets.symmetric(horizontal: 50.0),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        var pontos = 50;

        return new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: new ListTile(
                title: new Text("Usuário $index"),
                leading: new Image(
                  image: new AssetImage("assets/icons/icons-user2.png"),
                ),
                subtitle: new Text("${pontos - index*3} pontos"),
                trailing: _champions(index),
              ),
            ),
            new Divider()
          ],
        );
      },
    );
  }

  Widget _champions(index) {
    if (index == 0) {
      return new Container(
          width: 36.0,
          height: 36.0,
          child: new Image.asset("assets/icons/icons-medal-1-trophy.png"));
    } else if (index == 1) {
      return new Container(
          width: 36.0,
          height: 36.0,
          child: new Image.asset("assets/icons/icons-medal-2.png"));
    } else if (index == 2) {
      return new Container(
          width: 36.0,
          height: 36.0,
          child: new Image.asset("assets/icons/icons-medal-3.png"));
    } else {
      return null;
    }
  }
}
