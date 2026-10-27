import 'package:flutter/material.dart';
import '../data/conversas.dart';
import '../theme/app_colors.dart';
import '../utils/datas.dart';

class BalaoChat extends StatelessWidget {
  final MensagemChat mensagem;

  /// Mensagens de quem está usando a tela ficam à direita.
  final bool ladoDireito;

  const BalaoChat({super.key, required this.mensagem, required this.ladoDireito});

  @override
  Widget build(BuildContext context) {
    final m = mensagem;
    final autor = switch (m.autor) {
      AutorMensagem.tutor => null,
      AutorMensagem.ia => 'Assistente IA',
      AutorMensagem.equipe => 'Equipe • ${m.nome ?? ''}',
    };
    final destaque = m.autor == AutorMensagem.equipe;
    final fundo = ladoDireito
        ? AppColors.verde
        : destaque
            ? AppColors.chip
            : Colors.white;
    final corTexto = ladoDireito ? Colors.white : AppColors.texto;

    return Align(
      alignment: ladoDireito ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        decoration: BoxDecoration(
          color: fundo,
          border: ladoDireito ? null : Border.all(color: AppColors.borda),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(ladoDireito ? 14 : 2),
            bottomRight: Radius.circular(ladoDireito ? 2 : 14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (autor != null)
              Text(
                autor,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ladoDireito ? Colors.white70 : AppColors.verdeEscuro,
                ),
              ),
            Text(m.texto, style: TextStyle(color: corTexto)),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                Datas.hora(m.hora),
                style: TextStyle(
                  fontSize: 10,
                  color: ladoDireito ? Colors.white70 : AppColors.textoSuave,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalaoDigitando extends StatelessWidget {
  const BalaoDigitando({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.borda),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          'digitando...',
          style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textoSuave),
        ),
      ),
    );
  }
}

class CampoMensagem extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> aoEnviar;
  final String dica;

  const CampoMensagem({
    super.key,
    required this.controller,
    required this.aoEnviar,
    this.dica = 'Escreva sua mensagem...',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.send,
            onSubmitted: aoEnviar,
            decoration: InputDecoration(hintText: dica),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () => aoEnviar(controller.text),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.verde,
            fixedSize: const Size(50, 50),
          ),
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
