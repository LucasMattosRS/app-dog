import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class BanhoEquipeScreen extends StatefulWidget {
  const BanhoEquipeScreen({super.key});

  @override
  State<BanhoEquipeScreen> createState() => _BanhoEquipeScreenState();
}

class _BanhoEquipeScreenState extends State<BanhoEquipeScreen> {
  static const _filtros = [null, StatusBanho.agendado, StatusBanho.emAtendimento, StatusBanho.concluido];
  int _filtro = 0;

  static String rotulo(StatusBanho s) => switch (s) {
        StatusBanho.agendado => 'Agendado',
        StatusBanho.emAtendimento => 'Em atendimento',
        StatusBanho.concluido => 'Concluído',
      };

  @override
  Widget build(BuildContext context) {
    final filtro = _filtros[_filtro];
    final lista =
        DadosDemo.atendimentos.where((a) => filtro == null || a.status == filtro).toList();

    return TelaApp(
      titulo: 'Banho e tosa da equipe',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FiltroAbas(
            opcoes: const ['Hoje', 'Agendados', 'Em atendimento', 'Concluídos'],
            selecionada: _filtro,
            aoSelecionar: (i) => setState(() => _filtro = i),
          ),
          const SizedBox(height: 12),
          for (final a in lista)
            _CardAtendimento(atendimento: a, aoMudar: () => setState(() {})),
        ],
      ),
    );
  }
}

class _CardAtendimento extends StatelessWidget {
  final Atendimento atendimento;
  final VoidCallback aoMudar;

  const _CardAtendimento({required this.atendimento, required this.aoMudar});

  @override
  Widget build(BuildContext context) {
    final a = atendimento;

    final infos = switch (a.status) {
      StatusBanho.agendado => [
          _Info(icone: Icons.schedule, rotulo: 'Início previsto', valor: a.inicioPrevisto),
        ],
      StatusBanho.emAtendimento => [
          _Info(icone: Icons.schedule, rotulo: 'Início', valor: Datas.hora(a.inicio!)),
          _Info(
            icone: Icons.timer_outlined,
            rotulo: 'Tempo de atendimento',
            valor: Datas.duracao(DateTime.now().difference(a.inicio!)),
          ),
        ],
      StatusBanho.concluido => [
          _Info(icone: Icons.schedule, rotulo: 'Início', valor: Datas.hora(a.inicio!)),
          _Info(icone: Icons.flag_outlined, rotulo: 'Término', valor: Datas.hora(a.fim!)),
        ],
    };

    final botao = switch (a.status) {
      StatusBanho.agendado => FilledButton(
          onPressed: () {
            a
              ..status = StatusBanho.emAtendimento
              ..inicio = DateTime.now();
            aoMudar();
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            backgroundColor: AppColors.verdeEscuro,
          ),
          child: const Text('Iniciar atendimento'),
        ),
      StatusBanho.emAtendimento => FilledButton(
          onPressed: () {
            a
              ..status = StatusBanho.concluido
              ..fim = DateTime.now();
            Atividades.instancia.registrar(
              tipo: TipoAtividade.banho,
              pet: a.pet,
              titulo: 'Banho e tosa concluído',
              detalhe: 'Duração: ${Datas.duracao(a.fim!.difference(a.inicio!))} • ${a.vinculo}',
            );
            aoMudar();
          },
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(44)),
          child: const Text('Finalizar atendimento'),
        ),
      StatusBanho.concluido => OutlinedButton(
          onPressed: () => avisar(
            context,
            '${a.pet}: atendimento concluído às ${Datas.hora(a.fim!)}. Pronto para a saída.',
          ),
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
          child: const Text('Ver detalhes'),
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarPet(a.pet),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.pet, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          a.raca,
                          style: const TextStyle(fontSize: 12, color: AppColors.textoSuave),
                        ),
                      ],
                    ),
                  ),
                  Selo(_BanhoEquipeScreenState.rotulo(a.status)),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Selo(a.vinculo, icone: Icons.link),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.fundo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: infos),
              ),
              const SizedBox(height: 10),
              botao,
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final String valor;

  const _Info({required this.icone, required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icone, size: 20, color: AppColors.textoSuave),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rotulo, style: const TextStyle(fontSize: 11, color: AppColors.textoSuave)),
                Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
