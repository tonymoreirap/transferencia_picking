class EstoquePk {
  String id;
  String idProduto;
  String descProduto;
  String idEndereco;
  String qtdEstoque;
  String dtValidade;
  String lote;

  EstoquePk(
      {this.id,
        this.idProduto,
        this.descProduto,
        this.idEndereco,
        this.qtdEstoque,
        this.dtValidade,
        this.lote});

  EstoquePk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProduto = json['idProduto'];
    descProduto = json['descProduto'];
    idEndereco = json['idEndereco'];
    qtdEstoque = json['qtdEstoque'];
    dtValidade = json['dtValidade'];
    lote = json['lote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idProduto'] = this.idProduto;
    data['descProduto'] = this.descProduto;
    data['idEndereco'] = this.idEndereco;
    data['qtdEstoque'] = this.qtdEstoque;
    data['dtValidade'] = this.dtValidade;
    data['lote'] = this.lote;
    return data;
  }
}
