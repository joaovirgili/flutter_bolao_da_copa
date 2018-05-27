import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  Future<Map<String, dynamic>> _groupsJson;
  Future<Map<String, dynamic>> _eliminationJson;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal() {
    updateData();
  }

  updateData() {
    _groupsJson = this.getJson("http://www.srgoool.com.br/call?ajax=get_classificacao2&id_fase=1796");
    _eliminationJson = this.getJson("http://www.srgoool.com.br/call?ajax=get_chaves&id_ano_campeonato=434");
  }

  getGroupsJson() {
    return this._groupsJson;
  }

  getEliminationJson() {
    return this._eliminationJson;
  }

  Future<Map<String, dynamic>> getJson(url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var teste = json.decode(response.body);
      return teste;
    }
    else {
      return null;
    }
  }
}



