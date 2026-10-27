import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class EquipePermissoesScreen extends StatefulWidget {
  const EquipePermissoesScreen({super.key});

  @override
  State<EquipePermissoesScreen> createState() => _EquipePermissoesScreenState();
}

class _EquipePermissoesScreenState extends State<EquipePermissoesScreen> {
  void _adicionar() {
    final nome = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo membro'),
        content: TextField(
          controller: nome,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nome do funcionário'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 40)),
            onPressed: () {
              if (nome.text.trim().isEmpty) return;
              setState(() {
                DadosDemo.membros.add(
                  Membro(
                    nome: nome.text.trim(),
                    funcao: DadosDemo.funcoes.first,
                    acessos: {for (final p in DadosDemo.permissoes) p: p == 'Agenda'},
                  ),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Equipe e permissões',
      iconeTitulo: Icons.groups,
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Secao(
            titulo: 'Membros da equipe',
            acao: FilledButton.icon(
              onPressed: _adicionar,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                textStyle: const TextStyle(fontSize: 13),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Adicionar'),
            ),
            child: Column(
              children: [
                for (final m in DadosDemo.membros)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        AvatarPessoa(m.nome),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(m.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borda),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: m.funcao,
                              isDense: true,
                              style: const TextStyle(fontSize: 13, color: AppColors.texto),
                              items: [
                                for (final f in DadosDemo.funcoes)
                                  DropdownMenuItem(value: f, child: Text(f)),
                              ],
                              onChanged: (v) => setState(() => m.funcao = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Secao(
            titulo: 'Permissões de acesso',
            child: Table(
              columnWidths: const {0: FlexColumnWidth(1.4)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    const SizedBox(),
                    for (final p in DadosDemo.permissoes)
                      Text(
                        p,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                for (final m in DadosDemo.membros)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            AvatarPessoa(m.nome, raio: 14),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                m.nome,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (final p in DadosDemo.permissoes)
                        Transform.scale(
                          scale: 0.75,
                          child: Switch(
                            value: m.acessos[p] ?? false,
                            activeTrackColor: AppColors.verde,
                            onChanged: (v) => setState(() => m.acessos[p] = v),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => avisar(context, 'Acessos salvos'),
            child: const Text('Salvar acesso'),
          ),
        ],
      ),
    );
  }
}
