import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';
import 'cuidados_screen.dart';

class AgendaEquipeScreen extends StatefulWidget {
  const AgendaEquipeScreen({super.key});

  @override
  State<AgendaEquipeScreen> createState() => _AgendaEquipeScreenState();
}

class _AgendaEquipeScreenState extends State<AgendaEquipeScreen> {
  DateTime _dia = DateTime.now();

  void _mudarDia(int delta) => setState(() => _dia = _dia.add(Duration(days: delta)));

  Future<void> _escolherDia() async {
    final dia = await showDatePicker(
      context: context,
      initialDate: _dia,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (dia != null) setState(() => _dia = dia);
  }

  void _acao(TarefaAgenda t, String acao) {
    switch (acao) {
      case 'cuidados':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CuidadosScreen(pet: t.pet, raca: t.raca, servico: t.servico),
          ),
        );
      case 'entrada':
        if (t.entrada != null) return;
        setState(() => t.entrada = DateTime.now());
        Atividades.instancia.registrar(
          tipo: TipoAtividade.entradaSaida,
          pet: t.pet,
          titulo: 'Entrada registrada',
          detalhe: t.servico,
        );
        avisar(context, 'Entrada de ${t.pet} registrada às ${Datas.hora(t.entrada!)}');
      case 'saida':
        if (t.saida != null) return;
        setState(() => t.saida = DateTime.now());
        Atividades.instancia.registrar(
          tipo: TipoAtividade.entradaSaida,
          pet: t.pet,
          titulo: 'Saída registrada',
          detalhe: t.servico,
        );
        avisar(context, 'Saída de ${t.pet} registrada às ${Datas.hora(t.saida!)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Agenda da equipe',
      tituloGrande: true,
      acoes: [
        IconButton(
          onPressed: _escolherDia,
          icon: const Icon(Icons.calendar_month_outlined, size: 28),
        ),
      ],
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              _BotaoQuadrado(icone: Icons.arrow_back, aoTocar: () => _mudarDia(-1)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borda),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.event, size: 18, color: AppColors.verdeEscuro),
                      const SizedBox(width: 6),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            Datas.extenso(_dia),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _BotaoQuadrado(icone: Icons.arrow_forward, aoTocar: () => _mudarDia(1)),
            ],
          ),
          const SizedBox(height: 14),
          for (final t in DadosDemo.agenda)
            _CardTarefa(
              tarefa: t,
              aoMudar: () => setState(() {}),
              aoAcao: (acao) => _acao(t, acao),
            ),
        ],
      ),
    );
  }
}

class _BotaoQuadrado extends StatelessWidget {
  final IconData icone;
  final VoidCallback aoTocar;

  const _BotaoQuadrado({required this.icone, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borda),
      ),
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icone, color: AppColors.verdeEscuro),
        ),
      ),
    );
  }
}

class _CardTarefa extends StatelessWidget {
  final TarefaAgenda tarefa;
  final VoidCallback aoMudar;
  final ValueChanged<String> aoAcao;

  const _CardTarefa({
    required this.tarefa,
    required this.aoMudar,
    required this.aoAcao,
  });

  @override
  Widget build(BuildContext context) {
    final t = tarefa;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  AvatarPet(t.pet, raio: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.pet,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(t.servico, style: const TextStyle(color: AppColors.textoSuave)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.chip,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t.horario,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.verdeEscuro,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: aoAcao,
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'cuidados', child: Text('Registrar cuidados')),
                      PopupMenuItem(value: 'entrada', child: Text('Registrar entrada')),
                      PopupMenuItem(value: 'saida', child: Text('Registrar saída')),
                    ],
                  ),
                ],
              ),
              if (t.entrada != null || t.saida != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (t.entrada != null)
                      Selo('Entrada ${Datas.hora(t.entrada!)}', icone: Icons.login),
                    const SizedBox(width: 6),
                    if (t.saida != null)
                      Selo('Saída ${Datas.hora(t.saida!)}', icone: Icons.logout),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.fundo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            for (var i = 0; i < t.itens.length; i++)
                              InkWell(
                                onTap: () {
                                  if (t.feitos.remove(i)) {
                                    aoMudar();
                                    return;
                                  }
                                  t.feitos.add(i);
                                  Atividades.instancia.registrar(
                                    tipo: TipoAtividade.rotina,
                                    pet: t.pet,
                                    titulo: '${t.itens[i]} concluído',
                                    detalhe: t.feitos.length == t.itens.length
                                        ? '${t.servico} • todas as tarefas finalizadas'
                                        : t.servico,
                                  );
                                  aoMudar();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Icon(
                                        t.feitos.contains(i)
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        size: 20,
                                        color: t.feitos.contains(i)
                                            ? AppColors.verdeEscuro
                                            : AppColors.textoSuave,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(t.itens[i], style: const TextStyle(fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 16),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detalhes da tarefa',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(t.detalhes, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
