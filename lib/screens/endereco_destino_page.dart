import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transferencia_picking/api/endereco_api.dart';
import 'package:transferencia_picking/api/transferenciapk_api.dart';
import 'package:transferencia_picking/components/app_endereco_extenso.dart';
import 'package:transferencia_picking/components/app_text.dart';
import 'package:transferencia_picking/components/app_tipo_armazenagem.dart';
import 'package:transferencia_picking/models/endereco.dart';
import 'package:transferencia_picking/models/estoquepk.dart';
import 'package:transferencia_picking/models/transferenciapk.dart';
import 'package:transferencia_picking/screens/produto_page.dart';

class EnderecoDestinoPage extends StatefulWidget {
  final EstoquePk _estoquePk;

  EnderecoDestinoPage(this._estoquePk);

  @override
  _EnderecoDestinoPageState createState() =>
      _EnderecoDestinoPageState(_estoquePk);
}

class _EnderecoDestinoPageState extends State<EnderecoDestinoPage> {
  final EstoquePk _estoquePk;

  _EnderecoDestinoPageState(this._estoquePk);

//  GlobalKey
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//  FocusNode
  FocusNode _focusButtonFinalizar = FocusNode();
  FocusNode _focusEnderecoDestino = FocusNode();
  FocusNode _focusKeyBoard = FocusNode();

//Controller
  final _edtEnderecoController = TextEditingController();

//Classes
  TransferenciaPk _transferenciaPk = TransferenciaPk();
  TransferenciapkApi _transferenciapkApi = TransferenciapkApi();
  EnderecoApi _enderecoApi = EnderecoApi();
  Endereco _endereco;

  Widget body;

  @override
  void initState() {
    body = _body();
//    _focusKeyBoard = FocusNode();
  }

  @override
  void dispose() {
    _focusKeyBoard.dispose();
    _focusEnderecoDestino.dispose();
    _focusButtonFinalizar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Endereço de destino"),
        ),
        body: body,
      ),
    );
  }

  _bodyLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          AppText(
            "Endereço destino",
            "Informe o endereço de destino",
//            autofocus: true,
            scan: true,
            controller: _edtEnderecoController,
            keyboardType: TextInputType.number,
            onFieldSubmitted: _onCodEnderecoSubmitted,
            validator: (text) => _validateEnderecoDestino(text),
            focusNode: _focusEnderecoDestino,
          ),
          /*RawKeyboardListener(
            focusNode: _focusKeyBoard,
            onKey: _onTextFieldKey,
            child: 
          ),*/
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Endereço:  " +
                    (_endereco == null ? "00" : _endereco.codEndereco)),
                Text("Depósito: " +
                    (_endereco == null ? "00" : _endereco.codDeposito)),
              ],
            ),
          ),
          EnderecoExtenso(_endereco),
          AppTipoArmazenagem(_endereco),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text("Voltar"),
                onPressed: _onClickVoltar,
              ),
              Container(
                width: 140.0,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Finalizar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _onClickFinalizar,
                  focusNode: _focusButtonFinalizar,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onCodEnderecoSubmitted(text) async {
    debugPrint("Endereço: " + text);
    setState(() {
      body = FutureBuilder<Endereco>(
          future: _enderecoApi.GetEndereco(text),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              debugPrint("Dados: " + snapshot.data.toString());
              _endereco = snapshot.data;
              if (_endereco.codEndereco == null) _endereco = null;
              return _body();
            } else if (snapshot.hasError) {
              debugPrint("ERROR: " + snapshot.toString());
              _endereco = null;
              return _body();
            } else {
              return _bodyLoading();
            }
          });
    });
    _focusEnderecoDestino.unfocus();
//    FocusScope.of(context).requestFocus(_focusButtonFinalizar);
  }

  _onClickFinalizar() {
    if (!_formKey.currentState.validate()) return;
    _transferenciaPk.id = _estoquePk.id;
    _transferenciaPk.idProduto = _estoquePk.idProduto;
    _transferenciaPk.idEnderecoOrigem = _estoquePk.idEndereco;
    _transferenciaPk.idEnderecoDestino = _edtEnderecoController.text;

    if (!_validaFinalizar()) return;

    setState(() {
      body = FutureBuilder<bool>(
          future: _transferenciapkApi.Transferir(_transferenciaPk),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              debugPrint("Dados: " + snapshot.data.toString());
              return _body();
            } else if (snapshot.hasError) {
              debugPrint("ERROR: " + snapshot.toString());
              return _body();
            } else {
              return _bodyLoading();
            }
          });
    });
//    _transferenciapkApi.Transferir(transferenciaPk)
  }

  _onClickVoltar() {
    Navigator.pop(context, ProdutoPage(_endereco));
  }

  _validateEnderecoDestino(String text) {
    if ((_endereco == null) | (text == "")) {
      return "Endereço obrigatório.";
    }
  }

  void _onTextFieldKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      print("event.logicalKey--: ${event.logicalKey}");
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        print("LogicalKeyboardKey.enter--: ${event.logicalKey}");
        _onCodEnderecoSubmitted(_edtEnderecoController.text);
      } else if (event.data is RawKeyEventDataAndroid) {
        final data = event.data as RawKeyEventDataAndroid;
        if (data.keyCode == 13) {
          print("keyCode: ${data.keyCode}");
//          _onCodEnderecoSubmitted;
        }
      }
    }
  }

  bool _validaFinalizar() {
    var ok = true;

    if (_endereco.codEndereco == _estoquePk.idEndereco) {
      var snackbar = SnackBar(content: Text("Endereço destino deve ser diferente do origem."));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      ok = false;
    }
    return ok;
  }
}
