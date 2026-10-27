class ItemTreino {
  final String nome;
  final bool concluido;

  const ItemTreino(this.nome, {this.concluido = true});
}

class SessaoTreino {
  final DateTime data;
  final String titulo;
  final List<ItemTreino> itens;
  final String observacao;

  const SessaoTreino({
    required this.data,
    required this.titulo,
    required this.itens,
    required this.observacao,
  });
}
