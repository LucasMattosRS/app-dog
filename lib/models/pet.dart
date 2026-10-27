class Pet {
  final String nome;
  final String raca;
  final String sexo;
  final int idade;
  final String porte;
  final List<String> vacinas;
  final String alimentacao;
  final String tutorNome;
  final String tutorTelefone;
  final String tutorEmail;

  const Pet({
    required this.nome,
    required this.raca,
    required this.sexo,
    required this.idade,
    required this.porte,
    required this.vacinas,
    required this.alimentacao,
    required this.tutorNome,
    required this.tutorTelefone,
    required this.tutorEmail,
  });
}
