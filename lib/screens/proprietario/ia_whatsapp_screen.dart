import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tela_app.dart';

class IaWhatsappScreen extends StatelessWidget {
  const IaWhatsappScreen({super.key});

  static const _conversa = [
    (false, 'Posso reservar a creche e pedir busca e banho no final do dia?'),
    (true, 'Sim, posso orientar a solicitação. Qual é o pet, a data e o endereço de busca?'),
    (false, 'É o Thor, amanhã. Rua das Acácias, 320.'),
    (
      true,
      'Perfeito! Registrei: creche amanhã para o Thor, busca na Rua das Acácias, 320 '
          'e banho antes da saída. A equipe vai confirmar o horário. 🐾',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'IA no WhatsApp',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Opção para responder dúvidas frequentes e apoiar o primeiro atendimento.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textoSuave),
            ),
          ),
          const SizedBox(height: 16),
          for (final (ehIa, texto) in _conversa) _Balao(ehIa: ehIa, texto: texto),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3C4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Exceções são encaminhadas para a equipe',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Card(
            child: ListTile(
              leading: Icon(Icons.rule, color: AppColors.verde),
              title: Text(
                'O sistema usa as regras do dono e encaminha exceções à equipe.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Balao extends StatelessWidget {
  final bool ehIa;
  final String texto;

  const _Balao({required this.ehIa, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: ehIa ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ehIa ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ehIa ? 'Assistente do estabelecimento' : 'Tutor',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeEscuro,
              ),
            ),
            const SizedBox(height: 2),
            Text(texto),
          ],
        ),
      ),
    );
  }
}
