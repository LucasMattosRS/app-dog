class Datas {
  static const meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  static const mesesCurtos = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
    'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
  ];

  static const diasSemana = [
    'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo',
  ];

  static const diasCurtos = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  static String doisDigitos(int n) => n.toString().padLeft(2, '0');

  static String curta(DateTime d) =>
      '${doisDigitos(d.day)}/${doisDigitos(d.month)}/${d.year}';

  static String hora(DateTime d) =>
      '${doisDigitos(d.hour)}:${doisDigitos(d.minute)}';

  static String comHora(DateTime d) =>
      '${curta(d)} • ${doisDigitos(d.hour)}h${doisDigitos(d.minute)}';

  static String mesAno(DateTime d) => '${meses[d.month - 1]} ${d.year}';

  static String extenso(DateTime d) =>
      '${diasSemana[d.weekday - 1]}, ${d.day} de '
      '${meses[d.month - 1].toLowerCase()} de ${d.year}';

  static String duracao(Duration d) =>
      '${doisDigitos(d.inHours)}:${doisDigitos(d.inMinutes % 60)}:'
      '${doisDigitos(d.inSeconds % 60)}';
}
