import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:transferencia_picking/models/endereco.dart';
import 'package:http/http.dart' as http;

class EnderecoApi {
  var url =
      "http://192.168.1.2:8099/DataSnap/rest/TServiceEndereco/GetEndereco/";

  Future<Endereco> GetEndereco(String codEndereco) async {
    final response = await http.get(url + codEndereco);
    if (response.statusCode == 200) {
      debugPrint("response.body: " + response.body);
      return Endereco.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao buscar endereço');
    }
  }
}
