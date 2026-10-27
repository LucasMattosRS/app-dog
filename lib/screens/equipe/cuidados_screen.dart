import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class CuidadosScreen extends StatefulWidget {
  final String pet;
  final String raca;
  final String servico;

  const CuidadosScreen({
    super.key,
    required this.pet,
    required this.raca,
    required this.servico,
  });

  @override
  State<CuidadosScreen> createState() => _CuidadosScreenState();
}

class _CuidadosScreenState extends State<CuidadosScreen> {
  static const _itens = [
    (Icons.rice_bowl_outlined, 'Alimentação'),
    (Icons.water_drop_outlined, 'Água'),
    (Icons.hotel_outlined, 'Descanso'),
    (Icons.medication_outlined, 'Medicação conforme orientação'),
  ];

  final _marcados = <int>{0, 1, 2};
  final _observacao = TextEditingController();

  @override
  void dispose() {
    _observacao.dispose();
    super.dispose();
  }

  void _registrar() {
    if (_marcados.isEmpty) {
      avisar(context, 'Marque pelo menos um cuidado');
      return;
    }
    final itens = [for (final i in _marcados.toList()..sort()) _itens[i].$2];
    final observacao = _observacao.text.trim();

    setState(() {
      DadosDemo.historicoCuidados.insert(
        0,
        RegistroCuidado(
          pet: widget.pet,
          hora: DateTime.now(),
          itens: itens,
          observacao: observacao,
          responsavel: Atividades.funcionarioLogado,
        ),
      );
      _marcados.clear();
      _observacao.clear();
    });
    Atividades.instancia.registrar(
      tipo: TipoAtividade.cuidado,
      pet: widget.pet,
      titulo: 'Cuidado registrado',
      detalhe: observacao.isEmpty ? itens.join(', ') : '${itens.join(', ')}\n$observacao',
    );
    avisar(context, 'Cuidado registrado para ${widget.pet}');
  }

  @override
  Widget build(BuildContext context) {
    final historico =
        DadosDemo.historicoCuidados.where((r) => r.pet == widget.pet).toList();

    return TelaApp(
      titulo: 'Cuidados',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              AvatarPet(widget.pet, raio: 52),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pet,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.raca, style: const TextStyle(color: AppColors.textoSuave)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        Selo(widget.servico),
                        const Selo('Hoje', cor: AppColors.textoSuave, fundo: AppColors.cinza),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const TituloSecao('Registro de cuidados'),
          for (var i = 0; i < _itens.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  onTap: () => setState(
                    () => _marcados.contains(i) ? _marcados.remove(i) : _marcados.add(i),
                  ),
                  contentPadding: const EdgeInsets.only(left: 6, right: 12),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _marcados.contains(i),
                        activeColor: AppColors.verdeEscuro,
                        onChanged: (v) => setState(
                          () => v == true ? _marcados.add(i) : _marcados.remove(i),
                        ),
                      ),
                      Icon(_itens[i].$1, color: AppColors.textoSuave),
                    ],
                  ),
                  title: Text(_itens[i].$2),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          const Rotulo('Observações'),
          TextField(
            controller: _observacao,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText:
                  'Descreva como foi o cuidado, comportamento do pet ou alguma observação importante...',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _registrar, child: const Text('Registrar cuidado')),
          const SizedBox(height: 20),
          TituloSecao('Histórico de ${widget.pet}', icone: Icons.history),
          if (historico.isEmpty)
            const Text('Nenhum registro ainda.', style: TextStyle(color: AppColors.textoSuave)),
          for (final r in historico)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: AppColors.verde),
                  title: Text(
                    '${Datas.hora(r.hora)} • ${r.responsavel}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    r.observacao.isEmpty
                        ? r.itens.join(', ')
                        : '${r.itens.join(', ')}\n${r.observacao}',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
