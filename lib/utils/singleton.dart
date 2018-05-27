import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  var _groupsJson;
  var _eliminationJson;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal() {
    updateData();
  }

  updateData() {
    _groupsJson = this.getJson("http://www.srgoool.com.br/call?ajax=get_classificacao2&id_fase=1796", "jogos");
    _eliminationJson = this.getJson("http://www.srgoool.com.br/call?ajax=get_chaves&id_ano_campeonato=434", "fases");
  }

  getGroupsJson() {
    return this._groupsJson;
  }

  getEliminationJson() {
    return this._eliminationJson;
  }

  Future getJson(url, level) async {
    print("getting $level");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("$level loaded");
      var teste = json.decode(response.body)[level];
      // print(teste);
      // print(teste[0]);
      return teste;
    }
  }
}



