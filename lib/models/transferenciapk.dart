class TransferenciaPk {
  String id;
  String idEnderecoOrigem;
  String idEnderecoDestino;
  String idProduto;
  String qtdTransferida;

  TransferenciaPk(
      {this.id,
        this.idEnderecoOrigem,
        this.idEnderecoDestino,
        this.idProduto,
        this.qtdTransferida});

  TransferenciaPk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEnderecoOrigem = json['idEnderecoOrigem'];
    idEnderecoDestino = json['idEnderecoDestino'];
    idProduto = json['idProduto'];
    qtdTransferida = json['qtdTransferida'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idEnderecoOrigem'] = this.idEnderecoOrigem;
    data['idEnderecoDestino'] = this.idEnderecoDestino;
    data['idProduto'] = this.idProduto;
    data['qtdTransferida'] = this.qtdTransferida;
    return data;
  }
}