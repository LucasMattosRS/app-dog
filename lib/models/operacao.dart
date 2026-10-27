import 'package:flutter/material.dart';

class Cobranca {
  final String servico;
  final String descricao;
  final DateTime vencimento;
  final double valor;
  bool pago;

  Cobranca({
    required this.servico,
    required this.descricao,
    required this.vencimento,
    required this.valor,
    this.pago = false,
  });
}

class TarefaAgenda {
  final String pet;
  final String raca;
  final String servico;
  final String horario;
  final List<String> itens;
  final Set<int> feitos;
  final String detalhes;
  DateTime? entrada;
  DateTime? saida;

  TarefaAgenda({
    required this.pet,
    required this.raca,
    required this.servico,
    required this.horario,
    required this.itens,
    required this.detalhes,
    Set<int>? feitos,
  }) : feitos = feitos ?? {};
}

class RegistroCuidado {
  final String pet;
  final DateTime hora;
  final List<String> itens;
  final String observacao;
  final String responsavel;

  const RegistroCuidado({
    required this.pet,
    required this.hora,
    required this.itens,
    required this.observacao,
    required this.responsavel,
  });
}

enum StatusViagem { aBuscar, emTransporte, entregue }

class Viagem {
  final String pet;
  final String raca;
  final String tutor;
  final String telefone;
  final String horaBusca;
  final String enderecoBusca;
  final String bairroBusca;
  final String horaEntrega;
  final String enderecoEntrega;
  final String bairroEntrega;
  StatusViagem status;

  Viagem({
    required this.pet,
    required this.raca,
    required this.tutor,
    required this.telefone,
    required this.horaBusca,
    required this.enderecoBusca,
    required this.bairroBusca,
    required this.horaEntrega,
    required this.enderecoEntrega,
    required this.bairroEntrega,
    required this.status,
  });
}

enum StatusBanho { agendado, emAtendimento, concluido }

class Atendimento {
  final String pet;
  final String raca;
  final String vinculo;
  final String inicioPrevisto;
  StatusBanho status;
  DateTime? inicio;
  DateTime? fim;

  Atendimento({
    required this.pet,
    required this.raca,
    required this.vinculo,
    required this.inicioPrevisto,
    required this.status,
    this.inicio,
    this.fim,
  });
}

class Membro {
  final String nome;
  String funcao;
  final Map<String, bool> acessos;

  Membro({required this.nome, required this.funcao, required this.acessos});
}

class Despesa {
  final String categoria;
  final IconData icone;
  final Color cor;
  double valor;

  Despesa({
    required this.categoria,
    required this.icone,
    required this.cor,
    required this.valor,
  });
}

class ServicoPreco {
  final String nome;
  final IconData icone;
  final Color cor;
  final String unidade;
  double? preco;

  ServicoPreco({
    required this.nome,
    required this.icone,
    required this.cor,
    required this.unidade,
    this.preco,
  });
}

enum TipoAtividade { rotina, cuidado, entradaSaida, taxi, banho, foto }

class Atividade {
  final TipoAtividade tipo;
  final String pet;
  final String titulo;
  final String detalhe;
  final String responsavel;
  final DateTime hora;

  const Atividade({
    required this.tipo,
    required this.pet,
    required this.titulo,
    required this.detalhe,
    required this.responsavel,
    required this.hora,
  });
}
