import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transferencia_picking/api/estoquepk_api.dart';
import 'package:transferencia_picking/components/app_text.dart';
import 'package:transferencia_picking/models/endereco.dart';
import 'package:transferencia_picking/models/estoquepk.dart';
import 'package:transferencia_picking/screens/endereco_destino_page.dart';

class ProdutoPage extends StatefulWidget {
  final Endereco _endereco;

  ProdutoPage(this._endereco);

  @override
  _ProdutoPageState createState() => _ProdutoPageState(_endereco);
}

class _ProdutoPageState extends State<ProdutoPage> {
  final Endereco _endereco;

//  GlobalKey
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//  FocusNode
  FocusNode _focusQtdTransf;
  FocusNode _focusButtonProximo;

//Controller
  var _produtoController = TextEditingController();
  var _embalagemController = TextEditingController();
  var _fatorController = TextEditingController();
  var _qtdDisponivelController = TextEditingController();
  var _qtdTransfController = TextEditingController();

//Classes
  EstoquePk _estoquePk;
  EstoquepkApi _estoquepkApi = EstoquepkApi();
  Widget body;

  _ProdutoPageState(this._endereco);

  @override
  void initState() {
    _focusQtdTransf = FocusNode();
    _focusButtonProximo = FocusNode();
    body = _body();
  }

  @override
  void dispose() {
    _produtoController.dispose();
    _embalagemController.dispose();
    _fatorController.dispose();
    _qtdDisponivelController.dispose();
    _qtdTransfController.dispose();
    _focusQtdTransf.dispose();
    _focusButtonProximo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Produto"),
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
            "Produto",
            "Informe o produto",
//            autofocus: true,
            keyboardType: TextInputType.number,
            onFieldSubmitted: _onCodProdutoSubmitted,
            controller: _produtoController,
            validator: (text) => _validadeProduto(text),
          ),
          Container(
            height: 100.0,
            padding: EdgeInsets.all(8.0),
            child: Text(
              (_estoquePk == null ? "" : _estoquePk.descProduto),
              style: TextStyle(color: Colors.grey, fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                    width: 55.0,
                    child: AppText(
                      "Emb.",
                      "",
                      controller: _embalagemController,
                    )),
                SizedBox(
                  width: 5.0,
                ),
                SizedBox(
                    width: 60.0,
                    child: AppText(
                      "Fator.",
                      "",
                      controller: _fatorController,
                    )),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                    child: AppText(
                  "Disponível.",
                  "",
                  controller: _qtdDisponivelController,
                )),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                    child: AppText(
                  "Qtd. Transf.",
                  "",
                  keyboardType: TextInputType.number,
                  controller: _qtdTransfController,
                  validator: (text) => _validadeQtdTransf(text),
                  focusNode: _focusQtdTransf,
                  onFieldSubmitted: _onQtdTransfSubmitted,
                )),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          /*RaisedButton(
            color: Colors.blue,
            child: Text(
              "Incluir",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _onClickIncluir,
          ),*/
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: _onClickCancelar,
              ),
              FlatButton(
                child: Text("Limpar"),
                onPressed: _onClickLimpar,
              ),
              Container(
                width: 90.0,
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

  void _onClickIncluir() {}

  void _onClickCancelar() {}

  void _onClickProximo() {
    if (!_formKey.currentState.validate()) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EnderecoDestinoPage(_estoquePk)));
  }

  void _onClickLimpar() {}

  _onCodProdutoSubmitted(text) {
    setState(() {
      body = FutureBuilder<EstoquePk>(
          future: _estoquepkApi.GetEstoque(_endereco.codEndereco, text),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              debugPrint("Dados: " + snapshot.data.toString());
              _estoquePk = snapshot.data;
              if (snapshot.data == null) {
                var snackbar = SnackBar(
                    content:
                        Text("Endereço destino deve ser diferente do origem."));
                _scaffoldKey.currentState.showSnackBar(snackbar);
                return null;
              } else {
                _preencheValores();
                if (_estoquePk.idEndereco == null) _estoquePk = null;
                return _body();
              }
            } else if (snapshot.hasError) {
              debugPrint("ERROR: " + snapshot.toString());
              _estoquePk = null;
              return _body();
            } else {
              return _bodyLoading();
            }
          });
    });

    FocusScope.of(context).requestFocus(_focusQtdTransf);
  }

  _preencheValores() {
    _produtoController.text = _estoquePk.idProduto;
    _embalagemController.text = "UND";
    _fatorController.text = "1";
    _qtdDisponivelController.text = _estoquePk.qtdEstoque;
    _qtdTransfController.text = "";
  }

  _validadeQtdTransf(String text) {
    if ((text == "0") | (text.isEmpty)) {
      return "Qtd. inválida.";
    }
  }

  _validadeProduto(text) {
    if ((_estoquePk == null) | (text.isEmpty)) {
      return 'Produto obrigatório.';
    }
    return null;
  }

  _onQtdTransfSubmitted() {
    print("_onQtdTransfSubmitted: --->>");
    _focusQtdTransf.unfocus();
//    FocusScope.of(context).requestFocus(_focusButtonProximo);
  }
}
