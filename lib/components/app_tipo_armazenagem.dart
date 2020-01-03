import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transferencia_picking/models/endereco.dart';

class AppTipoArmazenagem extends StatelessWidget {
  final Endereco endereco;

  AppTipoArmazenagem(this.endereco);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Tipo armazenagem"),
          Text(
            (endereco == null? "...":endereco.GetTipoEndereco()),
            style: TextStyle(
              fontSize: 20.0,
//              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
