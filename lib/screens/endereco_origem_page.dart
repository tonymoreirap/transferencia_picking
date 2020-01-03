import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transferencia_picking/api/endereco_api.dart';
import 'package:transferencia_picking/components/app_endereco_extenso.dart';
import 'package:transferencia_picking/components/app_text.dart';
import 'package:transferencia_picking/components/app_tipo_armazenagem.dart';
import 'package:transferencia_picking/models/endereco.dart';
import 'package:transferencia_picking/screens/produto_page.dart';

class EnderecoOrigemPage extends StatefulWidget {
  @override
  _EnderecoOrigemPageState createState() => _EnderecoOrigemPageState();
}

class _EnderecoOrigemPageState extends State<EnderecoOrigemPage> {

//  FormKey
  final _formKey = GlobalKey<FormState>();

//  FocusNode
  FocusNode _focusButtonProximo;

//Controller
  final _edtEnderecoController = TextEditingController();

//Classes
  Endereco _endereco;
  EnderecoApi _enderecoApi = EnderecoApi();
  Widget body;

  @override
  void initState() {
    body = _body();
//    _edtEnderecoController.addListener(_listenerCodEndereco);
    _focusButtonProximo = FocusNode();
  }

  @override
  void dispose() {
    _edtEnderecoController.dispose();
    _focusButtonProximo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Transferência de picking"),
        ),
        body: body,

      ),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          AppText(
            "Endereço origem",
            "Informe o endereço de origem",
            autofocus: true,
            scan: true,
            controller: _edtEnderecoController,
            keyboardType: TextInputType.number,
            onFieldSubmitted: _onCodEnderecoSubmitted,
            validator: _validadeCodEndereco,
          ),
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
                child: Text("Cancelar"),
                onPressed: _onClickCancelar(context),
              ),
              Container(
                width: 140.0,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Próximo",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _onClickProximo,
                  focusNode: _focusButtonProximo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _bodyLoading() {
    return Center(
      child: CircularProgressIndicator(),
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
    FocusScope.of(context).requestFocus(_focusButtonProximo);
  }

  _onClickProximo() {
    if (_formKey.currentState.validate())
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProdutoPage(_endereco)));
  }

  _onClickCancelar(BuildContext buildContext) {
    /*Scaffold.of(buildContext)
        .showSnackBar(SnackBar(content: Text("Transferência cancelada.")));*/
  }

  String _validadeCodEndereco(String text) {
    if ((_endereco == null) | (text == "")) {
      return "Endereço obrigatório.";
    }
  }

  _listenerCodEndereco() {
    if (_edtEnderecoController.text.isEmpty) {
      setState(() {
        _endereco = null;
      });
      return;
    }
    print("listenerCodEndereco: ${_edtEnderecoController.text}");
    _onCodEnderecoSubmitted(_edtEnderecoController.text);
    FocusScope.of(context).requestFocus(_focusButtonProximo);
  }
}
