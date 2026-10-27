import 'package:flutter/material.dart';
import '../../data/conversas.dart';
import '../../theme/app_colors.dart';
import '../../widgets/balao_chat.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

/// Conversa de um tutor vista pela equipe ou pelo dono, que podem responder.
class ConversaScreen extends StatefulWidget {
  final Conversa conversa;
  final String nomeResponsavel;

  const ConversaScreen({
    super.key,
    required this.conversa,
    required this.nomeResponsavel,
  });

  @override
  State<ConversaScreen> createState() => _ConversaScreenState();
}

class _ConversaScreenState extends State<ConversaScreen> {
  final _campo = TextEditingController();

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  void _responder(String texto) {
    final resposta = texto.trim();
    if (resposta.isEmpty) return;
    _campo.clear();
    Conversas.instancia.enviar(
      widget.conversa,
      AutorMensagem.equipe,
      resposta,
      nome: widget.nomeResponsavel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.conversa;

    return TelaApp(
      titulo: c.tutor,
      rodape: CampoMensagem(
        controller: _campo,
        aoEnviar: _responder,
        dica: 'Responder como ${widget.nomeResponsavel}...',
      ),
      corpo: ListenableBuilder(
        listenable: Conversas.instancia,
        builder: (context, _) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  AvatarPet(c.pet, raio: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pet: ${c.pet}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  c.precisaEquipe
                      ? Selo(
                          'Precisa da equipe',
                          icone: Icons.support_agent,
                          cor: AppColors.alerta,
                          fundo: AppColors.alerta.withValues(alpha: 0.15),
                        )
                      : const Selo('Em dia', icone: Icons.check),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(16),
                children: [
                  for (final m in c.mensagens.reversed)
                    BalaoChat(mensagem: m, ladoDireito: m.autor != AutorMensagem.tutor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
