import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/formato.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class ServicosRegrasScreen extends StatefulWidget {
  const ServicosRegrasScreen({super.key});

  @override
  State<ServicosRegrasScreen> createState() => _ServicosRegrasScreenState();
}

class _ServicosRegrasScreenState extends State<ServicosRegrasScreen> {
  bool _fotos30Dias = true;

  void _editar(ServicoPreco s) {
    final valor = TextEditingController(
      text: s.preco?.toStringAsFixed(2).replaceAll('.', ',') ?? '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.nome),
        content: TextField(
          controller: valor,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixText: 'R\$ ',
            suffixText: '/ ${s.unidade}',
            hintText: '0,00',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 40)),
            onPressed: () {
              final v = double.tryParse(valor.text.replaceAll('.', '').replaceAll(',', '.'));
              if (v == null) return;
              setState(() => s.preco = v);
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Serviços e regras',
      iconeTitulo: Icons.pets,
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final s in DadosDemo.servicos)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  onTap: () => _editar(s),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: s.cor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(s.icone, color: Colors.white),
                  ),
                  title: Text(s.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: SizedBox(
                    width: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            s.preco != null
                                ? '${Formato.moeda(s.preco!)} / ${s.unidade}'
                                : s.unidade == 'km'
                                    ? 'Regra por km'
                                    : 'Preço definido pelo gestor',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: s.preco != null ? FontWeight.bold : FontWeight.normal,
                              color: s.preco != null ? AppColors.texto : AppColors.textoSuave,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Secao(
            titulo: 'Retenção de fotos',
            icone: Icons.photo_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tempo que as fotos das atividades ficam disponíveis no app.',
                  style: TextStyle(fontSize: 12, color: AppColors.textoSuave),
                ),
                OpcaoRadio(
                  texto: '48 horas',
                  selecionado: !_fotos30Dias,
                  aoTocar: () => setState(() => _fotos30Dias = false),
                ),
                OpcaoRadio(
                  texto: '30 dias',
                  selecionado: _fotos30Dias,
                  aoTocar: () => setState(() => _fotos30Dias = true),
                ),
              ],
            ),
          ),
          const Secao(
            titulo: 'Configurações da operação',
            icone: Icons.tune,
            child: Column(
              children: [
                _Config(Icons.access_time, 'Horário de funcionamento', '07:00 às 19:00'),
                _Config(Icons.groups_outlined, 'Capacidade', 'Hotel 30 • Creche 20 • Escolinha 15'),
                _Config(Icons.receipt_long_outlined, 'Cobrança', 'Vencimento todo dia 10'),
                _Config(Icons.local_taxi_outlined, 'Táxi Dog', 'Base por km, valor mínimo e taxa fixa'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Config extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _Config(this.icone, this.titulo, this.valor);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(icone, color: AppColors.verde),
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(valor),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
