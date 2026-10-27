import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

enum Servico { hotel, creche, escolinha }

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  Servico _servico = Servico.hotel;
  DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _entrada;
  DateTime? _saida;
  bool _solicitada = false;

  static const _info = {
    Servico.hotel: (
      Icons.hotel,
      'Hotel',
      'Hospedagem com cuidado e rotina personalizada para o seu pet.',
    ),
    Servico.creche: (
      Icons.wb_sunny_outlined,
      'Creche',
      'Dia de brincadeiras, socialização e descanso.',
    ),
    Servico.escolinha: (
      Icons.school,
      'Escolinha',
      'Rotina de aprendizado com atividades orientadas.',
    ),
  };

  void _tocarDia(DateTime dia) {
    setState(() {
      _solicitada = false;
      if (_entrada == null || _saida != null || dia.isBefore(_entrada!)) {
        _entrada = dia;
        _saida = null;
      } else {
        _saida = dia;
      }
    });
  }

  void _solicitar() {
    if (_entrada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha as datas no calendário')),
      );
      return;
    }
    setState(() => _solicitada = true);
  }

  @override
  Widget build(BuildContext context) {
    final info = _info[_servico]!;

    return TelaApp(
      titulo: 'Reservas',
      rodape: FilledButton(
        onPressed: _solicitada ? null : _solicitar,
        child: Text(_solicitada ? 'Reserva solicitada' : 'Solicitar reserva'),
      ),
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              for (final s in Servico.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: BotaoOpcao(
                      icone: _info[s]!.$1,
                      nome: _info[s]!.$2,
                      selecionado: s == _servico,
                      aoTocar: () => setState(() {
                        _servico = s;
                        _solicitada = false;
                      }),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _Calendario(
            mes: _mes,
            entrada: _entrada,
            saida: _saida,
            aoTocarDia: _tocarDia,
            aoMudarMes: (delta) => setState(
              () => _mes = DateTime(_mes.year, _mes.month + delta),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _CampoData(rotulo: 'Check-in', data: _entrada)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right, color: AppColors.textoSuave),
              ),
              Expanded(child: _CampoData(rotulo: 'Check-out', data: _saida)),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Serviço selecionado',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(info.$1, color: AppColors.verdeEscuro, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.$2,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              info.$3,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textoSuave,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textoSuave),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_solicitada) ...[
            const SizedBox(height: 12),
            const _StatusReserva(),
          ],
        ],
      ),
    );
  }
}

class _Calendario extends StatelessWidget {
  final DateTime mes;
  final DateTime? entrada;
  final DateTime? saida;
  final ValueChanged<DateTime> aoTocarDia;
  final ValueChanged<int> aoMudarMes;

  const _Calendario({
    required this.mes,
    required this.entrada,
    required this.saida,
    required this.aoTocarDia,
    required this.aoMudarMes,
  });

  static const _semana = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB'];

  @override
  Widget build(BuildContext context) {
    final vazios = DateTime(mes.year, mes.month, 1).weekday % 7;
    final totalDias = DateTime(mes.year, mes.month + 1, 0).day;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => aoMudarMes(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    Datas.mesAno(mes),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => aoMudarMes(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Row(
              children: [
                for (final d in _semana)
                  Expanded(
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textoSuave,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < vazios; i++) const SizedBox(),
                for (var dia = 1; dia <= totalDias; dia++)
                  _celula(DateTime(mes.year, mes.month, dia)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _celula(DateTime dia) {
    final ponta = dia == entrada || dia == saida;
    final noMeio = entrada != null &&
        saida != null &&
        dia.isAfter(entrada!) &&
        dia.isBefore(saida!);

    // Faixa contínua entre check-in e check-out, como no calendário do mockup.
    final temIntervalo = entrada != null && saida != null;
    final faixaEsquerda = noMeio || (temIntervalo && dia == saida);
    final faixaDireita = noMeio || (temIntervalo && dia == entrada);

    return GestureDetector(
      onTap: () => aoTocarDia(dia),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            top: 5,
            bottom: 5,
            child: Row(
              children: [
                Expanded(child: ColoredBox(color: faixaEsquerda ? AppColors.chip : Colors.transparent)),
                Expanded(child: ColoredBox(color: faixaDireita ? AppColors.chip : Colors.transparent)),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ponta ? AppColors.verde : null,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${dia.day}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: ponta ? FontWeight.bold : FontWeight.w600,
                color: ponta ? Colors.white : AppColors.texto,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampoData extends StatelessWidget {
  final String rotulo;
  final DateTime? data;

  const _CampoData({required this.rotulo, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.event, size: 20, color: AppColors.verde),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rotulo,
                    style: const TextStyle(fontSize: 11, color: AppColors.textoSuave),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      data == null ? '--/--/----' : Datas.curta(data!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusReserva extends StatelessWidget {
  const _StatusReserva();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.schedule, color: AppColors.verde, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status da reserva',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.chip,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Em análise',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.verdeEscuro,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sua solicitação está sendo avaliada. Em breve retornaremos.',
                    style: TextStyle(fontSize: 13, color: AppColors.textoSuave),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
