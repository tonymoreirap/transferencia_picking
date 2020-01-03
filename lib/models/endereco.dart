class Endereco {
  String codEndereco;
  String rua;
  String predio;
  String nivel;
  String apto;
  String situacao;
  String codTipoEnd;
  String codTipoAlmoxarifado;
  String codDeposito;
  String bloqueado;

  Endereco({
      this.codEndereco,
      this.rua,
      this.predio,
      this.nivel,
      this.apto,
      this.situacao,
      this.codTipoEnd,
      this.codTipoAlmoxarifado,
      this.codDeposito,
      this.bloqueado});

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      codEndereco: json['id'],
      rua: json['rua'],
      predio: json['predio'],
      nivel: json['nivel'],
      apto: json['apto'],
      situacao: json['situacao'],
      codTipoEnd: json['codTipoEnd'],
      codTipoAlmoxarifado: json['codTipoAlmoxarifado'],
      codDeposito: json['codDeposito'],
      bloqueado: json['bloqueado'],
    );
  }

  GetTipoEndereco() {
    switch (int.tryParse(codTipoEnd)) {
      case 0:
        return "Picking Fracionado";
      case 1:
        return "Picking Fechado";
      case 2:
        return "Pulmão P";
      case 3:
        return "Pulmão M";
      case 4:
        return "Pulmão G";
      case 5:
        return "Pulmão EG";
    }
  }
}
