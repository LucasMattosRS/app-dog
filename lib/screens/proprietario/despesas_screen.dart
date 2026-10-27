import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../utils/formato.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';
import '../../widgets/graficos.dart';

class DespesasScreen extends StatefulWidget {
  const DespesasScreen({super.key});

  @override
  State<DespesasScreen> createState() => _DespesasScreenState();
}

class _DespesasScreenState extends State<DespesasScreen> {
  static const _receitaMes = 48500.0;
  static const List<double> _receitasAnteriores = [38000, 41000, 44000, 40000, 46000];
  static const List<double> _despesasAnteriores = [22000, 24500, 23000, 25000, 24000];

  DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month);

  double get _totalDespesas =>
      DadosDemo.despesas.fold(0, (soma, d) => soma + d.valor);

  void _registrar() {
    var categoria = DadosDemo.despesas.first;
    final valor = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, atualizar) => AlertDialog(
          title: const Text('Registrar despesa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<Despesa>(
                value: categoria,
                isExpanded: true,
                items: [
                  for (final d in DadosDemo.despesas)
                    DropdownMenuItem(value: d, child: Text(d.categoria)),
                ],
                onChanged: (d) => atualizar(() => categoria = d!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valor,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(prefixText: 'R\$ ', hintText: '0,00'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(100, 40)),
              onPressed: () {
                final v = double.tryParse(valor.text.replaceAll('.', '').replaceAll(',', '.'));
                if (v == null) return;
                setState(() => categoria.valor += v);
                Navigator.pop(ctx);
                avisar(context, 'Despesa de ${Formato.moeda(v)} registrada');
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalDespesas;
    final meses = [
      for (var i = 5; i >= 0; i--) DateTime(_mes.year, _mes.month - i),
    ];

    return TelaApp(
      titulo: 'Despesas e relatórios',
      iconeTitulo: Icons.bar_chart,
      acoes: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.calendar_month_outlined, size: 28))],
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _mes = DateTime(_mes.year, _mes.month - 1)),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    Datas.mesAno(_mes),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _mes = DateTime(_mes.year, _mes.month + 1)),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const TituloSecao('Categorias de despesas'),
          for (final d in DadosDemo.despesas)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: d.cor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(d.icone, color: Colors.white),
                  ),
                  title: Text(d.categoria, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Formato.moeda(d.valor)),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Secao(
            titulo: 'Receitas x Despesas',
            icone: Icons.bar_chart,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Legenda(AppColors.verdeEscuro, 'Receitas'),
                    SizedBox(width: 16),
                    Legenda(AppColors.verdeClaro, 'Despesas'),
                  ],
                ),
                const SizedBox(height: 10),
                GraficoBarras(
                  rotulos: [for (final m in meses) Datas.meses[m.month - 1].substring(0, 3)],
                  series: [
                    [..._receitasAnteriores, _receitaMes],
                    [..._despesasAnteriores, total],
                  ],
                  cores: const [AppColors.verdeEscuro, AppColors.verdeClaro],
                ),
              ],
            ),
          ),
          Secao(
            titulo: 'Resultado de caixa',
            icone: Icons.account_balance_wallet_outlined,
            child: Column(
              children: [
                _LinhaValor('Entradas', _receitaMes),
                _LinhaValor('Saídas', -total),
                const Divider(),
                _LinhaValor('Resultado', _receitaMes - total, destaque: true),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: _registrar,
            icon: const Icon(Icons.add),
            label: const Text('Registrar despesa'),
          ),
        ],
      ),
    );
  }
}

class _LinhaValor extends StatelessWidget {
  final String rotulo;
  final double valor;
  final bool destaque;

  const _LinhaValor(this.rotulo, this.valor, {this.destaque = false});

  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(
      fontSize: destaque ? 16 : 14,
      fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
      color: destaque ? AppColors.verdeEscuro : AppColors.texto,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(rotulo, style: estilo)),
          Text(
            valor < 0 ? '- ${Formato.moeda(-valor)}' : Formato.moeda(valor),
            style: estilo,
          ),
        ],
      ),
    );
  }
}
