import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlacarGeral extends StatefulWidget {
  @override
  PlacarGeralState createState() {
    return new PlacarGeralState();
  }
}

class PlacarGeralState extends State<PlacarGeral> {
  @override
  Widget build(BuildContext context) {
    // return new Container(child: new Center(child: new Text("Placar geral")));
    return _rankingWidget();
  }

  Widget _rankingWidget() {
    return new StreamBuilder(
      stream: Firestore.instance
          .collection("users")
          .orderBy("pontos", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(
            child: CircularProgressIndicator(),
          );

        return new ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            // print(snapshot.data.documents[index]["pontos"]);
            var user = snapshot.data.documents[index];
            return new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(user["username"] != null
                      ? user["username"]
                      : user["email"]),
                  subtitle: new Text("${user["pontos"].toString()} pontos"),
                  trailing: _rankingTrailing(index),
                  // leading: new Container(
                  //     width: 48.0,
                  //     height: 48.0,
                  //     decoration: new BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       image: new DecorationImage(
                  //           fit: BoxFit.fill,
                  //           image: user["photo"] != null
                  //               ? new NetworkImage(user["photo"])
                  //               : new AssetImage(
                  //                   "assets/icons/icons-user.png")),
                  //     )),
                  leading: new CircleAvatar(backgroundImage:user["photo"] != null ? new NetworkImage(user["photo"]) : new AssetImage("assets/icons/icons-user2.png"),),
                ),
                new Divider(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _rankingTrailing(index) {
    String image = "";
    if (index == 0) {
      image = "assets/icons/icons-medal-1-trophy.png";
    } else if (index == 1) {
      image = "assets/icons/icons-medal-2.png";
    } else if (index == 2) {
      image = "assets/icons/icons-medal-3.png";
    }
    return image == ""
        ? null
        : new Image.asset(
            image,
            width: 32.0,
            height: 32.0,
          );
  }
}
