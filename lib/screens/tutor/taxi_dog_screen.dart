import 'package:flutter/material.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

enum TipoTransporte { busca, entrega, ambos }

class TaxiDogScreen extends StatefulWidget {
  const TaxiDogScreen({super.key});

  @override
  State<TaxiDogScreen> createState() => _TaxiDogScreenState();
}

class _TaxiDogScreenState extends State<TaxiDogScreen> {
  TipoTransporte _tipo = TipoTransporte.busca;
  DateTime? _horario;
  bool _enviado = false;
  final _endereco = TextEditingController();

  @override
  void dispose() {
    _endereco.dispose();
    super.dispose();
  }

  Future<void> _escolherHorario() async {
    final hoje = DateTime.now();
    final dia = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 90)),
    );
    if (dia == null || !mounted) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (hora == null) return;
    setState(() {
      _horario = DateTime(dia.year, dia.month, dia.day, hora.hour, hora.minute);
    });
  }

  void _solicitar() {
    if (_endereco.text.trim().isEmpty || _horario == null) {
      avisar(context, 'Informe o endereço e o horário desejado');
      return;
    }
    setState(() => _enviado = true);
    avisar(context, 'Pedido enviado! A equipe vai confirmar a disponibilidade.');
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Táxi Dog',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CabecalhoPet(nome: 'Thor', raca: 'Golden Retriever'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TituloSecao(
                    'Tipo de serviço',
                    acao: Selo(
                      _enviado ? 'Aguardando equipe' : 'A confirmar',
                      icone: Icons.schedule,
                    ),
                  ),
                  OpcaoRadio(
                    texto: 'Busca',
                    icone: Icons.directions_car,
                    selecionado: _tipo == TipoTransporte.busca,
                    aoTocar: () => setState(() => _tipo = TipoTransporte.busca),
                  ),
                  OpcaoRadio(
                    texto: 'Entrega',
                    icone: Icons.directions_car,
                    selecionado: _tipo == TipoTransporte.entrega,
                    aoTocar: () => setState(() => _tipo = TipoTransporte.entrega),
                  ),
                  OpcaoRadio(
                    texto: 'Busca e entrega',
                    icone: Icons.car_rental,
                    selecionado: _tipo == TipoTransporte.ambos,
                    aoTocar: () => setState(() => _tipo = TipoTransporte.ambos),
                  ),
                  const Rotulo('Endereço'),
                  TextField(
                    controller: _endereco,
                    decoration: const InputDecoration(
                      hintText: 'Digite o endereço completo',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const Rotulo('Horário desejado'),
                  CampoSelecao(
                    icone: Icons.event,
                    texto: _horario == null
                        ? 'Selecione o dia e horário'
                        : Datas.comHora(_horario!),
                    vazio: _horario == null,
                    aoTocar: _escolherHorario,
                  ),
                  const Rotulo('Referência'),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Ponto de referência (opcional)',
                      prefixIcon: Icon(Icons.sticky_note_2_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _solicitar,
                    icon: const Icon(Icons.directions_car),
                    label: const Text('Solicitar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
