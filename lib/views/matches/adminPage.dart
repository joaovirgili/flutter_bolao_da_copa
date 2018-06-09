import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/singleton.dart';

class AdminPage extends StatefulWidget {
  static const String routeName = "/AdminPage";

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  
   _insertGamesToDatabase() async {
    var matches = await new Singleton().getJson(
        "http://www.srgoool.com.br/call?ajax=get_classificacao2&id_fase=1796");
    for (var i = 0; i < matches["jogos"].length; i++) {
      var actualMatch = matches["jogos"][i];
      Map<String, dynamic> data = Map<String, dynamic>();
      data["data"] = actualMatch["data"];
      data["hora"] = actualMatch["hora"];
      data["id_clubem"] = actualMatch["id_clubem"];
      data["id_clubev"] = actualMatch["id_clubev"];
      data["m_clube"] = actualMatch["m_clube"];
      data["v_clube"] = actualMatch["v_clube"];
      data["nome_grupo"] = actualMatch["nome_grupo"];
      data["finalizado"] = false;
      data["placarm_tn"] = -1;
      data["placarv_tn"] = -1;
      Firestore.instance
          .collection("grupos")
          .document(
              "${i.toString().padLeft(2, '0')}${actualMatch["id_clubem"]}${actualMatch["id_clubev"]}")
          .updateData(data);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(child: new Text("Tela de Admin"),),
      appBar: new AppBar(
        title: new Text("Administrador do bolão"),
      ),
    );
  }
}