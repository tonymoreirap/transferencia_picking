import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:transferencia_picking/models/transferenciapk.dart';

class TransferenciapkApi {
  var url =
      "http://192.168.1.2:8099/DataSnap/rest/TServiceEstoquePk/Transferir";

  Future<bool> Transferir(TransferenciaPk transferenciaPk) async {
    String jsonString = json.encode(transferenciaPk.toJson());

    final response = await http.post(url, body: jsonString );
    if (response.statusCode == 200) {
      debugPrint("response.body: " + response.body);
      return true;
    } else {
      return false;
    }
  }
}