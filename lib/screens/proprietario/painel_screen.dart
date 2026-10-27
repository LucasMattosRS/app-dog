import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/graficos.dart';
import '../../widgets/tela_app.dart';
import 'concluidos_screen.dart';
import 'gestor_comum.dart';

class PainelScreen extends StatelessWidget {
  const PainelScreen({super.key});

  static const _ocupacao = [
    (Icons.home, 'Hotel', 0.82),
    (Icons.wb_sunny_outlined, 'Creche', 0.65),
    (Icons.school, 'Escolinha', 0.5),
    (Icons.pets, 'Adestramento', 0.7),
  ];

  static const _noLocal = [
    (Icons.hotel, 'Hotel', 28),
    (Icons.sports, 'Adestramento', 6),
    (Icons.pets, 'Total', 34),
    (Icons.groups, 'Em atividades', 22),
  ];

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Painel do gestor',
      menu: const MenuGestor(),
      acoes: acoesGestor(context),
      corpo: Builder(
        builder: (context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Secao(
              seta: true,
              titulo: 'Ocupação hoje',
              child: Row(
                children: [
                  const Medidor(valor: 0.78, rotulo: 'ocupação', tamanho: 116),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        for (final o in _ocupacao)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(o.$1, size: 16, color: AppColors.verde),
                                const SizedBox(width: 6),
                                SizedBox(
                                  width: 82,
                                  child: Text(o.$2, style: const TextStyle(fontSize: 12)),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: o.$3,
                                      minHeight: 7,
                                      color: AppColors.verde,
                                      backgroundColor: AppColors.chip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Secao(
              seta: true,
              titulo: 'Pets no local',
              icone: Icons.store_outlined,
              child: Row(
                children: [
                  for (final p in _noLocal)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        decoration: BoxDecoration(
                          color: AppColors.fundo,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(p.$1, color: AppColors.verde),
                            const SizedBox(height: 4),
                            Text(
                              p.$2,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            ),
                            Text(
                              '${p.$3}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Secao(
                      seta: true,
                      titulo: 'Reservas de hoje',
                      icone: Icons.event_note,
                      child: _ListaPontos([
                        ('Chegadas', 6),
                        ('Partidas', 4),
                        ('Em estadia', 18),
                        ('Creche (hoje)', 12),
                      ]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Secao(
                      seta: true,
                      titulo: 'Pendências',
                      icone: Icons.assignment_outlined,
                      child: _ListaPontos([
                        ('Check-in', 2),
                        ('Check-out', 1),
                        ('Avaliações', 3),
                        ('Contatos', 2),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const Secao(
              seta: true,
              titulo: 'Visão operacional',
              icone: Icons.bar_chart,
              child: Column(
                children: [
                  GraficoBarras(
                    rotulos: Datas.diasCurtos,
                    series: [
                      [4, 6, 5, 4, 5, 9, 6],
                      [2, 3, 3, 2, 3, 5, 4],
                    ],
                    cores: [AppColors.verdeEscuro, AppColors.verdeClaro],
                    empilhado: true,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Legenda(AppColors.verdeEscuro, 'Entradas'),
                      SizedBox(width: 16),
                      Legenda(AppColors.verdeClaro, 'Saídas'),
                    ],
                  ),
                ],
              ),
            ),
            ListenableBuilder(
              listenable: Atividades.instancia,
              builder: (context, _) => Secao(
                seta: true,
                titulo: 'Últimas finalizações da equipe',
                icone: Icons.task_alt,
                child: Column(
                  children: [
                    for (final a in Atividades.instancia.itens.take(3))
                      CardAtividade(atividade: a),
                    const Text(
                      'Veja tudo na aba Concluídos',
                      style: TextStyle(fontSize: 12, color: AppColors.textoSuave),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaPontos extends StatelessWidget {
  final List<(String, int)> itens;

  const _ListaPontos(this.itens);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final i in itens)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.verde, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(i.$1, style: const TextStyle(fontSize: 12))),
                Text('${i.$2}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
      ],
    );
  }
}
