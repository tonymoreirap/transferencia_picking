import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:transferencia_picking/models/estoquepk.dart';

class EstoquepkApi {
  var url =
      "http://192.168.1.99:8099/DataSnap/rest/TServiceEstoquePk/GetEstoque/";

  Future<EstoquePk> GetEstoque(codEndereco, codProduto) async {
    final response = await http.get(url + codEndereco + '/' + codProduto);
    if (response.statusCode == 200) {
      debugPrint("response.body: " + response.body);
      return EstoquePk.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao buscar estoque do produto');
    }
  }
}