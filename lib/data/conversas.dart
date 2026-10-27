import 'package:flutter/foundation.dart';

enum AutorMensagem { tutor, ia, equipe }

class MensagemChat {
  final AutorMensagem autor;
  final String texto;
  final DateTime hora;

  /// Nome de quem respondeu, quando a mensagem é da equipe ou do dono.
  final String? nome;

  const MensagemChat(this.autor, this.texto, this.hora, {this.nome});
}

class Conversa {
  final String tutor;
  final String pet;
  final List<MensagemChat> mensagens;

  /// A IA não soube resolver e encaminhou para a equipe.
  bool precisaEquipe;

  Conversa({
    required this.tutor,
    required this.pet,
    required this.mensagens,
    this.precisaEquipe = false,
  });

  MensagemChat get ultima => mensagens.last;
}

/// Conversas do atendimento por IA. O tutor conversa pelo app e a equipe
/// e o dono acompanham e respondem em tempo real.
class Conversas extends ChangeNotifier {
  Conversas._();

  static final instancia = Conversas._();

  final List<Conversa> itens = _exemplos();

  /// Conversa da tutora logada na demonstração (Ana Silva, do Thor).
  Conversa get doTutorLogado => itens.first;

  int get aguardandoEquipe => itens.where((c) => c.precisaEquipe).length;

  void enviar(
    Conversa conversa,
    AutorMensagem autor,
    String texto, {
    String? nome,
    bool encaminharEquipe = false,
  }) {
    conversa.mensagens.add(MensagemChat(autor, texto, DateTime.now(), nome: nome));
    if (encaminharEquipe) conversa.precisaEquipe = true;
    if (autor == AutorMensagem.equipe) conversa.precisaEquipe = false;
    notifyListeners();
  }

  static List<Conversa> _exemplos() {
    final agora = DateTime.now();
    DateTime antes(int minutos) => agora.subtract(Duration(minutes: minutos));

    return [
      Conversa(
        tutor: 'Ana Silva',
        pet: 'Thor',
        mensagens: [
          MensagemChat(
            AutorMensagem.ia,
            'Olá, Ana! 🐾 Sou o assistente do estabelecimento. Posso ajudar com '
            'reservas, Táxi Dog, banho e tosa, pagamentos e dúvidas sobre o Thor.',
            antes(30),
          ),
        ],
      ),
      Conversa(
        tutor: 'Carlos Souza',
        pet: 'Luna',
        precisaEquipe: true,
        mensagens: [
          MensagemChat(
            AutorMensagem.tutor,
            'A Luna está com a pata machucada, vocês podem dar uma olhada hoje?',
            antes(12),
          ),
          MensagemChat(
            AutorMensagem.ia,
            'Vou encaminhar sua mensagem para a equipe, que responde em breve.',
            antes(12),
          ),
        ],
      ),
      Conversa(
        tutor: 'Paula Lima',
        pet: 'Milo',
        mensagens: [
          MensagemChat(
            AutorMensagem.tutor,
            'Qual o horário de funcionamento?',
            antes(65),
          ),
          MensagemChat(
            AutorMensagem.ia,
            'Funcionamos de segunda a sábado, das 07:00 às 19:00.',
            antes(65),
          ),
        ],
      ),
    ];
  }
}
