import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../utils/formato.dart';
import '../../widgets/comum.dart';
import '../../widgets/graficos.dart';
import '../../widgets/tela_app.dart';
import 'gestor_comum.dart';

class FinanceiroScreen extends StatefulWidget {
  const FinanceiroScreen({super.key});

  @override
  State<FinanceiroScreen> createState() => _FinanceiroScreenState();
}

class _FinanceiroScreenState extends State<FinanceiroScreen> {
  static const _receitas = [
    (Icons.home, 'Hotel', 0.45),
    (Icons.wb_sunny_outlined, 'Creche', 0.25),
    (Icons.school, 'Escolinha', 0.18),
    (Icons.pets, 'Adestramento', 0.12),
  ];

  int _periodo = 0;
  DateTimeRange? _intervalo;

  double get _fator => switch (_periodo) {
        0 => 1,
        1 => 6.5,
        2 => 27,
        _ => (_intervalo?.duration.inDays ?? 14) + 1.0,
      };

  Future<void> _selecionarPeriodo(int i) async {
    if (i == 3) {
      final hoje = DateTime.now();
      final intervalo = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2025),
        lastDate: hoje,
        initialDateRange: DateTimeRange(
          start: hoje.subtract(const Duration(days: 14)),
          end: hoje,
        ),
      );
      if (intervalo == null) return;
      _intervalo = intervalo;
    }
    setState(() => _periodo = i);
  }

  @override
  Widget build(BuildContext context) {
    final f = _fator;
    final recebido = 1850 * f;
    final aReceber = 940 * f;
    final atrasado = 320 * f;

    return TelaApp(
      titulo: 'Financeiro',
      menu: const MenuGestor(),
      acoes: acoesGestor(context),
      corpo: Builder(
        builder: (context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FiltroAbas(
              opcoes: [
                'Hoje',
                'Semana',
                'Mês',
                _periodo == 3 && _intervalo != null
                    ? '${Datas.curta(_intervalo!.start).substring(0, 5)} – '
                        '${Datas.curta(_intervalo!.end).substring(0, 5)}'
                    : 'Período',
              ],
              selecionada: _periodo,
              aoSelecionar: _selecionarPeriodo,
            ),
            const SizedBox(height: 12),
            Secao(
              seta: true,
              titulo: _periodo == 0 ? 'Recebimentos do dia' : 'Recebimentos do período',
              icone: Icons.bar_chart,
              child: const GraficoLinha(
                valores: [120, 260, 310, 220, 380, 450, 330, 520, 610, 540, 500, 690, 630],
                rotulos: ['7h', '9h', '11h', '13h', '15h', '17h', '19h', '21h'],
              ),
            ),
            Row(
              children: [
                _CardStatus(
                  icone: Icons.check_circle,
                  rotulo: 'Recebido',
                  valor: recebido,
                  cor: AppColors.verde,
                  proporcao: 0.7,
                ),
                _CardStatus(
                  icone: Icons.schedule,
                  rotulo: 'A receber',
                  valor: aReceber,
                  cor: AppColors.verdeClaro,
                  proporcao: 0.45,
                ),
                _CardStatus(
                  icone: Icons.warning_amber,
                  rotulo: 'Em atraso',
                  valor: atrasado,
                  cor: AppColors.alerta,
                  proporcao: 0.2,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Secao(
              seta: true,
              titulo: 'Receitas por serviço',
              icone: Icons.donut_small_outlined,
              child: Row(
                children: [
                  GraficoRosca(
                    valores: [for (final r in _receitas) r.$3],
                    cores: AppColors.graficos,
                    tamanho: 110,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        for (var i = 0; i < _receitas.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(_receitas[i].$1, size: 16, color: AppColors.graficos[i]),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(_receitas[i].$2, style: const TextStyle(fontSize: 12)),
                                ),
                                Text(
                                  Formato.moeda(recebido * _receitas[i].$3),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
            const Secao(
              seta: true,
              titulo: 'Evolução de recebimentos',
              icone: Icons.stacked_bar_chart,
              child: GraficoBarras(
                rotulos: Datas.diasCurtos,
                series: [
                  [1500, 1800, 1300, 1650, 1900, 2600, 2300],
                ],
                cores: [AppColors.verdeEscuro],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardStatus extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final double valor;
  final Color cor;
  final double proporcao;

  const _CardStatus({
    required this.icone,
    required this.rotulo,
    required this.valor,
    required this.cor,
    required this.proporcao,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icone, size: 16, color: cor),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        rotulo,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                FittedBox(
                  child: Text(
                    Formato.moeda(valor),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: proporcao,
                    minHeight: 6,
                    color: cor,
                    backgroundColor: AppColors.chip,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
