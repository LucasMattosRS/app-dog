import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../utils/formato.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class CobrancasScreen extends StatefulWidget {
  const CobrancasScreen({super.key});

  @override
  State<CobrancasScreen> createState() => _CobrancasScreenState();
}

class _CobrancasScreenState extends State<CobrancasScreen> {
  int _aba = 0;

  void _pagar(Cobranca c, String forma) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pagar com $forma',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${c.descricao} • ${Formato.moeda(c.valor)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textoSuave),
              ),
              const SizedBox(height: 16),
              if (forma == 'Pix') ...[
                const Icon(Icons.qr_code_2, size: 140, color: AppColors.texto),
                OutlinedButton.icon(
                  onPressed: () => avisar(context, 'Código Pix copiado'),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar código Pix'),
                ),
              ] else
                const Text(
                  'Você será direcionado ao ambiente seguro do provedor de pagamentos.',
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => c.pago = true);
                  avisar(context, 'Pagamento confirmado!');
                },
                child: const Text('Confirmar pagamento (demonstração)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final abertas = DadosDemo.cobrancas.where((c) => !c.pago).toList();
    final pagas = DadosDemo.cobrancas.where((c) => c.pago).toList();

    return TelaApp(
      titulo: 'Cobranças',
      tituloGrande: true,
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FiltroAbas(
            opcoes: const ['Em aberto', 'Pagas'],
            selecionada: _aba,
            aoSelecionar: (i) => setState(() => _aba = i),
          ),
          const SizedBox(height: 14),
          if (_aba == 0) ...[
            const TituloSecao('Faturas em aberto'),
            if (abertas.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Nenhuma fatura em aberto. 🎉',
                  style: TextStyle(color: AppColors.textoSuave),
                ),
              ),
            for (final c in abertas)
              _CardFatura(cobranca: c, aoPagar: (forma) => _pagar(c, forma)),
            const SizedBox(height: 8),
          ],
          const TituloSecao('Histórico de pagamentos'),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < pagas.length; i++) ...[
                  if (i > 0) const Divider(indent: 16, endIndent: 16),
                  _LinhaPaga(cobranca: pagas[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFatura extends StatelessWidget {
  final Cobranca cobranca;
  final ValueChanged<String> aoPagar;

  const _CardFatura({required this.cobranca, required this.aoPagar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.chip,
                    child: Icon(Icons.description_outlined, color: AppColors.verde),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cobranca.servico,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(cobranca.descricao, style: const TextStyle(fontSize: 13)),
                        Text(
                          'Vencimento: ${Datas.curta(cobranca.vencimento)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textoSuave),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Selo(
                        'Pendente',
                        cor: AppColors.alerta,
                        fundo: AppColors.alerta.withValues(alpha: 0.15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Formato.moeda(cobranca.valor),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => aoPagar('Pix'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 42),
                        backgroundColor: AppColors.verdeEscuro,
                      ),
                      icon: const Icon(Icons.pix, size: 18),
                      label: const Text('Pix'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => aoPagar('Cartão'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 42)),
                      icon: const Icon(Icons.credit_card, size: 18),
                      label: const Text('Cartão'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinhaPaga extends StatelessWidget {
  final Cobranca cobranca;

  const _LinhaPaga({required this.cobranca});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColors.verde,
        child: Icon(Icons.check, color: Colors.white),
      ),
      title: Text(cobranca.servico, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        '${cobranca.descricao}\nVencimento: ${Datas.curta(cobranca.vencimento)}',
        style: const TextStyle(fontSize: 12),
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Selo('Pago'),
              const SizedBox(height: 4),
              Text(Formato.moeda(cobranca.valor), style: const TextStyle(fontSize: 12)),
            ],
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
