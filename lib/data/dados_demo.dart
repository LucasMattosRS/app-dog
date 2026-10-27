import 'package:flutter/material.dart';
import '../models/operacao.dart';
import '../models/pet.dart';
import '../models/sessao_treino.dart';
import '../theme/app_colors.dart';

class DadosDemo {
  // ---------- Tutor ----------

  static const thor = Pet(
    nome: 'Thor',
    raca: 'Golden Retriever',
    sexo: 'Macho',
    idade: 3,
    porte: 'Grande porte',
    vacinas: ['V10 em dia', 'Antirrábica em dia'],
    alimentacao: 'Ração super premium\n2 vezes ao dia',
    tutorNome: 'Ana Silva',
    tutorTelefone: '(11) 98877-6655',
    tutorEmail: 'ana.silva@email.com',
  );

  static const evolucaoTreino = 0.7;

  static const comandosEmAndamento = ['Sentar', 'Ficar', 'Deitar', 'Vir aqui'];

  static final sessoes = [
    SessaoTreino(
      data: DateTime(2026, 10, 24),
      titulo: 'Sentar e ficar',
      itens: const [
        ItemTreino('Sentar'),
        ItemTreino('Ficar'),
        ItemTreino('Deitar (em progresso)', concluido: false),
      ],
      observacao: 'Boa resposta aos comandos. Manter a rotina de reforço positivo.',
    ),
    SessaoTreino(
      data: DateTime(2026, 10, 17),
      titulo: 'Passeio sem puxar',
      itens: const [
        ItemTreino('Caminhar junto'),
        ItemTreino('Parar no comando'),
        ItemTreino('Vir aqui', concluido: false),
      ],
      observacao: 'Evolução no passeio. Menos ansiedade e mais foco.',
    ),
    SessaoTreino(
      data: DateTime(2026, 10, 10),
      titulo: 'Socialização',
      itens: const [
        ItemTreino('Interação com outros cães'),
        ItemTreino('Controle de excitação'),
        ItemTreino('Ficar', concluido: false),
      ],
      observacao: 'Ótimo comportamento. Mostrou mais segurança.',
    ),
  ];

  static final proximaSessao = DateTime(2026, 10, 31, 10);

  static const orientacoesEmCasa = [
    'Treinar "sentar" 3 vezes ao dia, sessões de 5 minutos.',
    'Recompensar logo após o comando certo.',
    'No passeio, parar sempre que a guia esticar.',
  ];

  static const fotoCapaThor = 'assets/images/pets/thor_capa.jpg';

  static const fotosThor = [
    'assets/images/pets/thor_1.jpg',
    'assets/images/pets/thor_2.jpg',
    'assets/images/pets/thor_3.jpg',
    'assets/images/pets/thor_4.jpg',
    'assets/images/pets/thor_5.jpg',
    'assets/images/pets/thor_6.jpg',
  ];

  static final cobrancas = [
    Cobranca(
      servico: 'Hotel',
      descricao: 'Estadia do Thor',
      vencimento: DateTime(2026, 11, 5),
      valor: 480,
    ),
    Cobranca(
      servico: 'Adestramento',
      descricao: 'Plano mensal - Thor',
      vencimento: DateTime(2026, 11, 10),
      valor: 650,
    ),
    Cobranca(
      servico: 'Banho',
      descricao: 'Banho do Thor',
      vencimento: DateTime(2026, 10, 20),
      valor: 85,
      pago: true,
    ),
    Cobranca(
      servico: 'Hotel',
      descricao: 'Estadia do Thor',
      vencimento: DateTime(2026, 10, 12),
      valor: 360,
      pago: true,
    ),
    Cobranca(
      servico: 'Adestramento',
      descricao: 'Plano mensal - Thor',
      vencimento: DateTime(2026, 10, 10),
      valor: 650,
      pago: true,
    ),
  ];

  // ---------- Equipe ----------

  static const petsDaCasa = [
    ('Thor', 'Golden Retriever'),
    ('Luna', 'Bernese'),
    ('Bella', 'Lhasa Apso'),
    ('Milo', 'Shih Tzu'),
    ('Mel', 'SRD'),
    ('Bento', 'Bulldog Francês'),
    ('Nina', 'Beagle'),
    ('Zeca', 'Border Collie'),
  ];

  static final agenda = [
    TarefaAgenda(
      pet: 'Thor',
      raca: 'Golden Retriever',
      servico: 'Hotel',
      horario: '08:00 – 09:00',
      itens: ['Passeio matinal', 'Alimentação', 'Brincadeiras', 'Higiene do espaço'],
      feitos: {0, 1},
      detalhes: 'Passeio de 30 minutos no jardim.',
    ),
    TarefaAgenda(
      pet: 'Luna',
      raca: 'Bernese',
      servico: 'Adestramento',
      horario: '10:00 – 11:00',
      itens: ['Aquecimento', 'Exercícios de obediência', 'Socialização', 'Feedback no app'],
      feitos: {0},
      detalhes: 'Trabalhar comando "fica" e "vem". Reforço positivo.',
    ),
    TarefaAgenda(
      pet: 'Bella',
      raca: 'Lhasa Apso',
      servico: 'Banho',
      horario: '14:00 – 15:00',
      itens: ['Banho e tosa', 'Limpeza das orelhas', 'Corte de unhas', 'Hidratação da pelagem'],
      detalhes: 'Utilizar shampoo hipoalergênico.',
    ),
    TarefaAgenda(
      pet: 'Mel',
      raca: 'SRD',
      servico: 'Creche',
      horario: '15:30 – 17:00',
      itens: ['Lanche da tarde', 'Recreação em grupo', 'Descanso'],
      detalhes: 'Mel é tímida: apresentar aos outros cães aos poucos.',
    ),
  ];

  static final historicoCuidados = [
    RegistroCuidado(
      pet: 'Thor',
      hora: DateTime.now().copyWith(hour: 8, minute: 40),
      itens: const ['Alimentação', 'Água'],
      observacao: 'Comeu toda a ração e brincou bastante.',
      responsavel: 'Ana',
    ),
  ];

  static final viagens = [
    Viagem(
      pet: 'Thor',
      raca: 'Golden Retriever',
      tutor: 'Ana Silva',
      telefone: '(11) 98877-6655',
      horaBusca: '08:00',
      enderecoBusca: 'Rua das Acácias, 320',
      bairroBusca: 'Jardim Paulista',
      horaEntrega: '17:00',
      enderecoEntrega: 'Rua dos Pinheiros, 1045',
      bairroEntrega: 'Vila Madalena',
      status: StatusViagem.aBuscar,
    ),
    Viagem(
      pet: 'Luna',
      raca: 'Bernese',
      tutor: 'Carlos Souza',
      telefone: '(11) 97766-5544',
      horaBusca: '09:30',
      enderecoBusca: 'Avenida Brasil, 1500',
      bairroBusca: 'Moema',
      horaEntrega: '18:00',
      enderecoEntrega: 'Rua Harmonia, 285',
      bairroEntrega: 'Sumaré',
      status: StatusViagem.emTransporte,
    ),
    Viagem(
      pet: 'Milo',
      raca: 'Shih Tzu',
      tutor: 'Paula Lima',
      telefone: '(11) 96655-4433',
      horaBusca: '07:45',
      enderecoBusca: 'Rua Lisboa, 640',
      bairroBusca: 'Pinheiros',
      horaEntrega: '16:20',
      enderecoEntrega: 'Rua Girassóis, 77',
      bairroEntrega: 'Vila Mariana',
      status: StatusViagem.entregue,
    ),
  ];

  static final atendimentos = [
    Atendimento(
      pet: 'Thor',
      raca: 'Golden Retriever',
      vinculo: 'Após a creche',
      inicioPrevisto: '13:00',
      status: StatusBanho.agendado,
    ),
    Atendimento(
      pet: 'Bella',
      raca: 'Lhasa Apso',
      vinculo: 'Antes da entrega',
      inicioPrevisto: '10:30',
      status: StatusBanho.emAtendimento,
      inicio: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Atendimento(
      pet: 'Luna',
      raca: 'Bernese',
      vinculo: 'Antes da entrega',
      inicioPrevisto: '09:00',
      status: StatusBanho.concluido,
      inicio: DateTime.now().copyWith(hour: 9, minute: 0),
      fim: DateTime.now().copyWith(hour: 10, minute: 15),
    ),
  ];

  // ---------- Proprietário ----------

  static const chegadasHoje = [
    ('Luna', 'Bernese', 'Hotel', '08:00'),
    ('Thor', 'Golden Retriever', 'Creche', '09:30'),
    ('Mel', 'SRD', 'Escolinha', '10:00'),
  ];

  static const partidasHoje = [
    ('Bento', 'Bulldog Francês', 'Hotel', '16:00'),
    ('Nina', 'Beagle', 'Creche', '17:30'),
    ('Zeca', 'Border Collie', 'Adestramento', '18:00'),
  ];

  static final solicitacoes = [
    ('Thor', 'Hotel', '12/11 a 15/11'),
    ('Nina', 'Creche', 'Seg, Qua e Sex'),
    ('Zeca', 'Adestramento', 'Pacote de 8 sessões'),
  ];

  static const permissoes = ['Agenda', 'Mídias', 'Táxi Dog', 'Financeiro'];

  static const funcoes = ['Monitor', 'Adestrador', 'Motorista', 'Banhista', 'Recepção'];

  static final membros = [
    Membro(
      nome: 'Ana',
      funcao: 'Monitor',
      acessos: {'Agenda': true, 'Mídias': true, 'Táxi Dog': false, 'Financeiro': false},
    ),
    Membro(
      nome: 'João',
      funcao: 'Adestrador',
      acessos: {'Agenda': true, 'Mídias': false, 'Táxi Dog': false, 'Financeiro': false},
    ),
    Membro(
      nome: 'Marina',
      funcao: 'Motorista',
      acessos: {'Agenda': true, 'Mídias': true, 'Táxi Dog': true, 'Financeiro': false},
    ),
  ];

  static final despesas = [
    Despesa(categoria: 'Aluguel', icone: Icons.home, cor: AppColors.verdeEscuro, valor: 8500),
    Despesa(categoria: 'Alimentação', icone: Icons.rice_bowl, cor: AppColors.verde, valor: 3200),
    Despesa(categoria: 'Equipe', icone: Icons.groups, cor: const Color(0xFF2E7D32), valor: 14800),
    Despesa(categoria: 'Limpeza', icone: Icons.cleaning_services, cor: const Color(0xFF43A047), valor: 950),
  ];

  static final servicos = [
    ServicoPreco(nome: 'Hotel', icone: Icons.hotel, cor: AppColors.verdeEscuro, unidade: 'diária'),
    ServicoPreco(nome: 'Creche', icone: Icons.wb_sunny_outlined, cor: AppColors.verde, unidade: 'dia'),
    ServicoPreco(nome: 'Escolinha', icone: Icons.school, cor: AppColors.verdeEscuro, unidade: 'mês'),
    ServicoPreco(nome: 'Adestramento', icone: Icons.pets, cor: AppColors.verde, unidade: 'sessão'),
    ServicoPreco(nome: 'Táxi Dog', icone: Icons.local_taxi, cor: AppColors.verdeEscuro, unidade: 'km'),
    ServicoPreco(nome: 'Banho e tosa', icone: Icons.content_cut, cor: AppColors.verde, unidade: 'serviço'),
  ];
}
