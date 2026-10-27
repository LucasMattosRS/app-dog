import 'package:flutter/foundation.dart';
import '../models/operacao.dart';

/// Registro de tudo que a equipe finaliza. As telas da equipe registram aqui
/// e as do proprietário acompanham em tempo real.
class Atividades extends ChangeNotifier {
  Atividades._();

  static final instancia = Atividades._();

  /// Na demonstração, as ações feitas no perfil Equipe ficam no nome dela.
  static const funcionarioLogado = 'Ana';

  final List<Atividade> itens = _exemplos();

  void registrar({
    required TipoAtividade tipo,
    required String pet,
    required String titulo,
    String detalhe = '',
    String responsavel = funcionarioLogado,
  }) {
    itens.insert(
      0,
      Atividade(
        tipo: tipo,
        pet: pet,
        titulo: titulo,
        detalhe: detalhe,
        responsavel: responsavel,
        hora: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  static List<Atividade> _exemplos() {
    final agora = DateTime.now();
    DateTime antes(int minutos) => agora.subtract(Duration(minutes: minutos));

    return [
      Atividade(
        tipo: TipoAtividade.taxi,
        pet: 'Milo',
        titulo: 'Entrega realizada',
        detalhe: 'Rua Girassóis, 77 - Vila Mariana',
        responsavel: 'Marina',
        hora: antes(20),
      ),
      Atividade(
        tipo: TipoAtividade.banho,
        pet: 'Luna',
        titulo: 'Banho e tosa concluído',
        detalhe: 'Duração: 01:15:00',
        responsavel: 'Ana',
        hora: antes(50),
      ),
      Atividade(
        tipo: TipoAtividade.foto,
        pet: 'Thor',
        titulo: 'Foto publicada',
        detalhe: 'Brincando no jardim',
        responsavel: 'Ana',
        hora: antes(75),
      ),
      Atividade(
        tipo: TipoAtividade.rotina,
        pet: 'Luna',
        titulo: 'Aquecimento concluído',
        detalhe: 'Adestramento',
        responsavel: 'João',
        hora: antes(110),
      ),
      Atividade(
        tipo: TipoAtividade.cuidado,
        pet: 'Thor',
        titulo: 'Cuidado registrado',
        detalhe: 'Alimentação, Água\nComeu toda a ração e brincou bastante.',
        responsavel: 'Ana',
        hora: antes(140),
      ),
      Atividade(
        tipo: TipoAtividade.taxi,
        pet: 'Luna',
        titulo: 'Busca realizada',
        detalhe: 'Avenida Brasil, 1500 - Moema',
        responsavel: 'Marina',
        hora: antes(180),
      ),
      Atividade(
        tipo: TipoAtividade.entradaSaida,
        pet: 'Thor',
        titulo: 'Entrada registrada',
        detalhe: 'Hotel',
        responsavel: 'Ana',
        hora: antes(240),
      ),
    ];
  }
}
