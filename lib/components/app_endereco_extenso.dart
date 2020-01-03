import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transferencia_picking/models/endereco.dart';

class EnderecoExtenso extends StatelessWidget {
  double _width = 60.0;
  double _height = 56.0;

  Endereco endereco;

  EnderecoExtenso(this.endereco);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _segmentoText("Rua"),
              _segmentoText("Prédio"),
              _segmentoText("Nível"),
              _segmentoText("Apto"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _segmentoEndereco(
                (endereco == null? "0":endereco.rua),
                textColor: Colors.white,
                color: Colors.black,
              ),
              _segmentoEndereco(
                (endereco == null? "0":endereco.predio),
                color: Colors.grey[100],
              ),
              _segmentoEndereco(
                (endereco == null? "0":endereco.nivel),
                textColor: Colors.white,
                color: Colors.black,
              ),
              _segmentoEndereco(
                (endereco == null? "0":endereco.apto),
                color: Colors.grey[100],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _segmentoText(text) {
    return Container(
                width: _width,
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ));
  }

  _segmentoEndereco(segmento, {textColor = Colors.black, color}) {
    return Container(
      child: Text(
        segmento,
        style: TextStyle(color: textColor, fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
      alignment: Alignment.center,
      color: color,
      width: _width,
      height: _height,
    );
  }
}
