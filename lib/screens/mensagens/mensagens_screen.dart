import 'package:flutter/material.dart';
import '../../data/conversas.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';
import 'conversa_screen.dart';

/// Conversas dos tutores com a IA, para a equipe e o dono acompanharem.
class MensagensScreen extends StatefulWidget {
  /// Nome usado nas respostas enviadas desta tela.
  final String nomeResponsavel;

  const MensagensScreen({super.key, required this.nomeResponsavel});

  @override
  State<MensagensScreen> createState() => _MensagensScreenState();
}

class _MensagensScreenState extends State<MensagensScreen> {
  int _filtro = 0;

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Mensagens',
      corpo: ListenableBuilder(
        listenable: Conversas.instancia,
        builder: (context, _) {
          final todas = Conversas.instancia.itens;
          final aguardando = Conversas.instancia.aguardandoEquipe;
          final lista = [
            for (final c in todas)
              if (_filtro == 0 ||
                  (_filtro == 1 && c.precisaEquipe) ||
                  (_filtro == 2 && !c.precisaEquipe))
                c,
          ]..sort((a, b) => b.ultima.hora.compareTo(a.ultima.hora));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: aguardando > 0 ? const Color(0xFFFFF4E0) : AppColors.chip,
                child: ListTile(
                  leading: Icon(
                    aguardando > 0 ? Icons.support_agent : Icons.smart_toy_outlined,
                    color: aguardando > 0 ? AppColors.alerta : AppColors.verdeEscuro,
                    size: 32,
                  ),
                  title: Text(
                    aguardando > 0
                        ? '$aguardando conversa(s) aguardando a equipe'
                        : 'A IA está dando conta das conversas',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'A IA responde com as regras do estabelecimento e encaminha o que não sabe.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FiltroAbas(
                opcoes: ['Todas', 'Aguardando ($aguardando)', 'Resolvidas'],
                selecionada: _filtro,
                aoSelecionar: (i) => setState(() => _filtro = i),
              ),
              const SizedBox(height: 12),
              if (lista.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Nenhuma conversa aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textoSuave),
                  ),
                ),
              for (final c in lista)
                _CardConversa(
                  conversa: c,
                  aoTocar: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConversaScreen(
                        conversa: c,
                        nomeResponsavel: widget.nomeResponsavel,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CardConversa extends StatelessWidget {
  final Conversa conversa;
  final VoidCallback aoTocar;

  const _CardConversa({required this.conversa, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    final c = conversa;
    final ultima = c.ultima;
    final prefixo = switch (ultima.autor) {
      AutorMensagem.tutor => '',
      AutorMensagem.ia => 'IA: ',
      AutorMensagem.equipe => '${ultima.nome}: ',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: InkWell(
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                AvatarPet(c.pet, raio: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${c.tutor} • ${c.pet}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$prefixo${ultima.texto}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: AppColors.textoSuave),
                      ),
                      if (c.precisaEquipe) ...[
                        const SizedBox(height: 6),
                        Selo(
                          'Precisa da equipe',
                          icone: Icons.support_agent,
                          cor: AppColors.alerta,
                          fundo: AppColors.alerta.withValues(alpha: 0.15),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      Datas.hora(ultima.hora),
                      style: const TextStyle(fontSize: 12, color: AppColors.textoSuave),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ícone de mensagens com o número de conversas aguardando a equipe.
class IconeMensagens extends StatelessWidget {
  const IconeMensagens({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Conversas.instancia,
      builder: (context, _) {
        final n = Conversas.instancia.aguardandoEquipe;
        return Badge(
          isLabelVisible: n > 0,
          label: Text('$n'),
          backgroundColor: AppColors.alerta,
          child: const Icon(Icons.chat_bubble_outline),
        );
      },
    );
  }
}
