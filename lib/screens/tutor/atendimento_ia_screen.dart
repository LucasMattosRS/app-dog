import 'package:flutter/material.dart';
import '../../data/conversas.dart';
import '../../theme/app_colors.dart';
import '../../widgets/balao_chat.dart';
import '../../widgets/tela_app.dart';

/// Chat do tutor com o assistente do estabelecimento.
/// Na demonstração as respostas vêm de regras simples por palavra-chave,
/// representando a IA que usa as regras definidas pelo dono.
class AtendimentoIaScreen extends StatefulWidget {
  const AtendimentoIaScreen({super.key});

  @override
  State<AtendimentoIaScreen> createState() => _AtendimentoIaScreenState();
}

class _AtendimentoIaScreenState extends State<AtendimentoIaScreen> {
  static const _sugestoes = [
    'Posso reservar a creche e pedir busca e banho no final do dia?',
    'Qual o horário de funcionamento?',
    'Como faço para pagar?',
    'O Thor pode tomar remédio aí?',
  ];

  static const _assuntos = [
    (
      ['reserv', 'hotel', 'creche', 'escolinha', 'hosped'],
      'Posso ajudar com a reserva! Me diga o serviço (hotel, creche ou escolinha) '
          'e o período. Eu registro a solicitação e a equipe confirma a vaga.',
    ),
    (
      ['táxi', 'taxi', 'busca', 'buscar', 'entrega', 'transporte'],
      'O Táxi Dog faz busca, entrega ou ambas. Preciso do endereço e do horário '
          'desejado. A cobrança é por km e a equipe confirma a disponibilidade.',
    ),
    (
      ['banho', 'tosa'],
      'Temos banho, tosa ou os dois juntos. Se o Thor estiver na creche ou no '
          'hotel, fazemos antes da saída. Qual dia e horário você prefere?',
    ),
    (
      ['pagar', 'pagamento', 'pix', 'cartão', 'cartao', 'cobrança', 'fatura', 'boleto'],
      'Você pode pagar pelo app, em Mais → Cobranças, com Pix ou cartão. '
          'Lá também ficam os vencimentos e o histórico.',
    ),
    (
      ['horário', 'horario', 'funciona', 'abre', 'fecha'],
      'Funcionamos de segunda a sábado, das 07:00 às 19:00.',
    ),
    (
      ['preço', 'preco', 'valor', 'quanto custa', 'quanto é'],
      'Os valores seguem a tabela do estabelecimento. Me diga o serviço que eu '
          'te passo o preço e as condições.',
    ),
    (
      ['foto', 'vídeo', 'video'],
      'As fotos do dia ficam em Mais → Fotos e rotina, já com a marca do '
          'estabelecimento, para você baixar e compartilhar.',
    ),
  ];

  final _campo = TextEditingController();
  bool _digitando = false;

  Conversa get _conversa => Conversas.instancia.doTutorLogado;

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  /// Devolve a resposta e se a mensagem precisa ser encaminhada à equipe.
  (String, bool) _responder(String pergunta) {
    final texto = pergunta.toLowerCase();
    final encontrados = [
      for (final (palavras, resposta) in _assuntos)
        if (palavras.any(texto.contains)) resposta,
    ];

    if (encontrados.length > 1) {
      return (
        'Sim, posso orientar a solicitação. Qual é o pet, a data e o endereço de busca?',
        false,
      );
    }
    if (encontrados.length == 1) return (encontrados.first, false);
    return (
      'Vou encaminhar sua mensagem para a equipe, que responde em breve por aqui. 🐾',
      true,
    );
  }

  Future<void> _enviar(String texto) async {
    final pergunta = texto.trim();
    if (pergunta.isEmpty || _digitando) return;

    _campo.clear();
    Conversas.instancia.enviar(_conversa, AutorMensagem.tutor, pergunta);
    setState(() => _digitando = true);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final (resposta, encaminhar) = _responder(pergunta);
    Conversas.instancia.enviar(
      _conversa,
      AutorMensagem.ia,
      resposta,
      encaminharEquipe: encaminhar,
    );
    setState(() => _digitando = false);
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Atendimento',
      rodape: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _sugestoes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ActionChip(
                label: Text(_sugestoes[i], style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.borda),
                onPressed: () => _enviar(_sugestoes[i]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          CampoMensagem(controller: _campo, aoEnviar: _enviar),
        ],
      ),
      corpo: Column(
        children: [
          const _FaixaAssistente(),
          Expanded(
            child: ListenableBuilder(
              listenable: Conversas.instancia,
              builder: (context, _) {
                final mensagens = _conversa.mensagens.reversed.toList();
                return ListView(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_digitando) const BalaoDigitando(),
                    for (final m in mensagens)
                      BalaoChat(mensagem: m, ladoDireito: m.autor == AutorMensagem.tutor),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FaixaAssistente extends StatelessWidget {
  const _FaixaAssistente();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.chip,
      child: const Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.verdeEscuro,
            child: Icon(Icons.smart_toy_outlined, size: 18, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Assistente virtual • responde com as regras do estabelecimento '
              'e encaminha exceções à equipe',
              style: TextStyle(fontSize: 12, color: AppColors.verdeEscuro),
            ),
          ),
        ],
      ),
    );
  }
}
