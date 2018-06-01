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
  bool isGroupsLoaded = false;
  bool isEliminationLoaded = false;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal() {
    // updateData();
  }

  // updateData() async {
  //   this.loading.value = true;
  //   _groupsJson = this.getJson("http://www.srgoool.com.br/call?ajax=get_classificacao2&id_fase=1796");
  //   _eliminationJson = this.getJson("http://www.srgoool.com.br/call?ajax=get_chaves&id_ano_campeonato=434");
  //   this.loading.value = false;
  //   print("loading false");
  // }

  showLoadingDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => new AlertDialog(
              content: new Row(
                children: <Widget>[
                  new CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
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
