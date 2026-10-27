import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../models/sessao_treino.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class AdestramentoScreen extends StatelessWidget {
  const AdestramentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessoes = DadosDemo.sessoes;

    return TelaApp(
      titulo: 'Adestramento',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Evolucao(valor: DadosDemo.evolucaoTreino),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comandos em andamento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (final c in DadosDemo.comandosEmAndamento)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.chip,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                c,
                                style: const TextStyle(
                                  color: AppColors.verdeEscuro,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Últimas sessões',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < sessoes.length; i++)
            _ItemLinhaDoTempo(
              sessao: sessoes[i],
              primeiro: i == 0,
              ultimo: i == sessoes.length - 1,
            ),
          const SizedBox(height: 12),
          Material(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(14),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: const Icon(Icons.event, color: AppColors.verdeEscuro, size: 32),
              title: const Text(
                'Próxima sessão',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(Datas.comHora(DadosDemo.proximaSessao)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => avisar(context, 'Sessão confirmada na agenda'),
            ),
          ),
          const SizedBox(height: 12),
          Secao(
            titulo: 'Orientações em casa',
            icone: Icons.home_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final o in DadosDemo.orientacoesEmCasa)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $o', style: const TextStyle(color: AppColors.textoSuave)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Evolucao extends StatelessWidget {
  final double valor;

  const _Evolucao({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.bar_chart, color: AppColors.verdeEscuro, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evolução geral',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: valor,
                      minHeight: 10,
                      color: AppColors.verdeEscuro,
                      backgroundColor: AppColors.chip,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${(valor * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemLinhaDoTempo extends StatelessWidget {
  final SessaoTreino sessao;
  final bool primeiro;
  final bool ultimo;

  const _ItemLinhaDoTempo({
    required this.sessao,
    required this.primeiro,
    required this.ultimo,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: primeiro ? 22 : 0,
                  bottom: ultimo ? null : 0,
                  height: ultimo ? 22 : null,
                  child: Container(width: 3, color: AppColors.verdeEscuro),
                ),
                Positioned(
                  top: 16,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      color: AppColors.verdeEscuro,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.chip,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              Datas.doisDigitos(sessao.data.day),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.verdeEscuro,
                              ),
                            ),
                            Text(
                              Datas.mesesCurtos[sessao.data.month - 1],
                              style: const TextStyle(fontSize: 11, color: AppColors.verdeEscuro),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sessao.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            for (final item in sessao.itens)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Icon(
                                      item.concluido
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 16,
                                      color: item.concluido
                                          ? AppColors.verde
                                          : AppColors.textoSuave,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(item.nome, style: const TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 16),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.edit_note, size: 16, color: AppColors.textoSuave),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                sessao.observacao,
                                style: const TextStyle(fontSize: 11, color: AppColors.textoSuave),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
