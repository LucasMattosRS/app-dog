import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/graficos.dart';
import '../../widgets/tela_app.dart';
import 'gestor_comum.dart';

class ReservasOcupacaoScreen extends StatefulWidget {
  const ReservasOcupacaoScreen({super.key});

  @override
  State<ReservasOcupacaoScreen> createState() => _ReservasOcupacaoScreenState();
}

class _ReservasOcupacaoScreenState extends State<ReservasOcupacaoScreen> {
  static const _servicos = ['Hotel', 'Creche', 'Escolinha', 'Adestramento'];
  static const _vagas = [(6, 30), (8, 20), (5, 15), (4, 8)];

  int _dia = DateTime.now().weekday - 1;
  int _servico = 0;

  void _confirmar() {
    final pendentes = DadosDemo.solicitacoes;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, atualizar) => AlertDialog(
          title: const Text('Solicitações pendentes'),
          content: SizedBox(
            width: 380,
            child: pendentes.isEmpty
                ? const Text('Nenhuma solicitação pendente.')
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final s in pendentes)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: AvatarPet(s.$1, raio: 18),
                          title: Text('${s.$1} • ${s.$2}'),
                          subtitle: Text(s.$3),
                          trailing: IconButton(
                            tooltip: 'Aprovar',
                            icon: const Icon(Icons.check_circle, color: AppColors.verde),
                            onPressed: () {
                              atualizar(() => pendentes.remove(s));
                              avisar(context, 'Reserva de ${s.$1} confirmada');
                            },
                          ),
                        ),
                    ],
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar')),
          ],
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final segunda = hoje.subtract(Duration(days: hoje.weekday - 1));

    return TelaApp(
      titulo: 'Reservas e ocupação',
      menu: const MenuGestor(),
      acoes: acoesGestor(context),
      corpo: Builder(
        builder: (context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    for (var i = 0; i < 7; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _dia = i),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: i == _dia ? AppColors.verde : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  Datas.diasCurtos[i],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: i == _dia ? Colors.white : AppColors.textoSuave,
                                  ),
                                ),
                                Text(
                                  '${segunda.add(Duration(days: i)).day}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: i == _dia ? Colors.white : AppColors.texto,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            FiltroAbas(
              opcoes: _servicos,
              selecionada: _servico,
              aoSelecionar: (i) => setState(() => _servico = i),
            ),
            const SizedBox(height: 10),
            Secao(
              seta: true,
              titulo: 'Vagas disponíveis',
              icone: Icons.event_available,
              child: Row(
                children: [
                  for (var i = 0; i < _servicos.length; i++)
                    Expanded(
                      child: Column(
                        children: [
                          AnelVagas(
                            livres: (_vagas[i].$1 + _dia * (i + 1)) % _vagas[i].$2,
                            total: _vagas[i].$2,
                            destaque: i == _servico,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _servicos[i],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: i == _servico ? FontWeight.bold : FontWeight.normal,
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
              titulo: 'Chegadas de hoje',
              icone: Icons.login,
              child: Column(
                children: [for (final c in DadosDemo.chegadasHoje) _LinhaMovimento(c)],
              ),
            ),
            Secao(
              seta: true,
              titulo: 'Partidas de hoje',
              icone: Icons.logout,
              child: Column(
                children: [for (final p in DadosDemo.partidasHoje) _LinhaMovimento(p)],
              ),
            ),
            FilledButton.icon(
              onPressed: _confirmar,
              icon: const Icon(Icons.event_available),
              label: Text('Confirmar reserva (${DadosDemo.solicitacoes.length})'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaMovimento extends StatelessWidget {
  final (String, String, String, String) dados;

  const _LinhaMovimento(this.dados);

  @override
  Widget build(BuildContext context) {
    final (pet, raca, servico, hora) = dados;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          AvatarPet(pet, raio: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(raca, style: const TextStyle(fontSize: 11, color: AppColors.textoSuave)),
              ],
            ),
          ),
          Selo(servico, icone: iconeServico(servico)),
          const SizedBox(width: 10),
          Text(hora, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
    );
  }
}
