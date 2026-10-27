import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';
import 'gestor_comum.dart';

(IconData, Color) visualAtividade(TipoAtividade tipo) => switch (tipo) {
      TipoAtividade.rotina => (Icons.checklist, AppColors.verdeEscuro),
      TipoAtividade.cuidado => (Icons.favorite, AppColors.verde),
      TipoAtividade.entradaSaida => (Icons.swap_horiz, const Color(0xFF2E7D32)),
      TipoAtividade.taxi => (Icons.local_taxi, const Color(0xFF00897B)),
      TipoAtividade.banho => (Icons.bathtub, const Color(0xFF43A047)),
      TipoAtividade.foto => (Icons.photo_camera, const Color(0xFF558B2F)),
    };

class ConcluidosScreen extends StatefulWidget {
  const ConcluidosScreen({super.key});

  @override
  State<ConcluidosScreen> createState() => _ConcluidosScreenState();
}

class _ConcluidosScreenState extends State<ConcluidosScreen> {
  static const _filtros = ['Todos', 'Rotina', 'Táxi Dog', 'Banho', 'Fotos'];
  int _filtro = 0;

  bool _passaNoFiltro(Atividade a) => switch (_filtro) {
        1 => const {
            TipoAtividade.rotina,
            TipoAtividade.cuidado,
            TipoAtividade.entradaSaida,
          }.contains(a.tipo),
        2 => a.tipo == TipoAtividade.taxi,
        3 => a.tipo == TipoAtividade.banho,
        4 => a.tipo == TipoAtividade.foto,
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Concluídos',
      menu: const MenuGestor(),
      acoes: acoesGestor(context),
      corpo: ListenableBuilder(
        listenable: Atividades.instancia,
        builder: (context, _) {
          final todas = Atividades.instancia.itens;
          final lista = todas.where(_passaNoFiltro).toList();
          final equipe = {for (final a in todas) a.responsavel};

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Secao(
                titulo: 'Finalizado pela equipe hoje',
                icone: Icons.task_alt,
                child: Row(
                  children: [
                    _Numero(rotulo: 'Atividades', valor: '${todas.length}'),
                    _Numero(rotulo: 'Na equipe', valor: '${equipe.length}'),
                    _Numero(
                      rotulo: 'Última',
                      valor: todas.isEmpty ? '--' : Datas.hora(todas.first.hora),
                    ),
                  ],
                ),
              ),
              FiltroAbas(
                opcoes: _filtros,
                selecionada: _filtro,
                aoSelecionar: (i) => setState(() => _filtro = i),
              ),
              const SizedBox(height: 12),
              if (lista.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Nada finalizado nesta categoria ainda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textoSuave),
                  ),
                ),
              for (final a in lista) CardAtividade(atividade: a),
            ],
          );
        },
      ),
    );
  }
}

class _Numero extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _Numero({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.fundo,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(rotulo, style: const TextStyle(fontSize: 11, color: AppColors.textoSuave)),
          ],
        ),
      ),
    );
  }
}

class CardAtividade extends StatelessWidget {
  final Atividade atividade;

  const CardAtividade({super.key, required this.atividade});

  @override
  Widget build(BuildContext context) {
    final a = atividade;
    final (icone, cor) = visualAtividade(a.tipo);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AvatarPet(a.pet, raio: 22),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: cor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(icone, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${a.pet} • ${a.titulo}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (a.detalhe.isNotEmpty)
                      Text(
                        a.detalhe,
                        style: const TextStyle(fontSize: 12, color: AppColors.textoSuave),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        AvatarPessoa(a.responsavel, raio: 9),
                        const SizedBox(width: 6),
                        Text(
                          'Por ${a.responsavel}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Datas.hora(a.hora),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Icon(Icons.check_circle, color: AppColors.verde, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
