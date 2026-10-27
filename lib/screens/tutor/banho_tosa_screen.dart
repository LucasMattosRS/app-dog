import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class BanhoTosaScreen extends StatefulWidget {
  const BanhoTosaScreen({super.key});

  @override
  State<BanhoTosaScreen> createState() => _BanhoTosaScreenState();
}

class _BanhoTosaScreenState extends State<BanhoTosaScreen> {
  static const _tipos = [
    (Icons.bathtub_outlined, 'Banho'),
    (Icons.content_cut, 'Tosa'),
    (Icons.spa_outlined, 'Banho e tosa'),
  ];

  int _tipo = 0;
  bool _aposCreche = true;
  DateTime? _data;
  TimeOfDay? _hora;

  Future<void> _escolherData() async {
    final hoje = DateTime.now();
    final dia = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 60)),
    );
    if (dia != null) setState(() => _data = dia);
  }

  Future<void> _escolherHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 14, minute: 0),
    );
    if (hora != null) setState(() => _hora = hora);
  }

  void _solicitar() {
    if (_data == null || _hora == null) {
      avisar(context, 'Escolha a data e o horário preferenciais');
      return;
    }
    avisar(context, '${_tipos[_tipo].$2} solicitado! A equipe vai confirmar a agenda.');
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Banho e tosa',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CabecalhoPet(nome: 'Thor', raca: 'Golden Retriever'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Rotulo('Tipo de serviço'),
                  Row(
                    children: [
                      for (var i = 0; i < _tipos.length; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: i == _tipos.length - 1 ? 0 : 8),
                            child: BotaoOpcao(
                              icone: _tipos[i].$1,
                              nome: _tipos[i].$2,
                              selecionado: i == _tipo,
                              aoTocar: () => setState(() => _tipo = i),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CheckboxListTile(
                    value: _aposCreche,
                    onChanged: (v) => setState(() => _aposCreche = v ?? false),
                    title: const Text('Após a creche / hotel'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    activeColor: AppColors.verdeEscuro,
                  ),
                  const Rotulo('Data preferencial'),
                  CampoSelecao(
                    icone: Icons.event,
                    texto: _data == null ? 'Selecione a data' : Datas.curta(_data!),
                    vazio: _data == null,
                    aoTocar: _escolherData,
                  ),
                  const Rotulo('Horário preferencial'),
                  CampoSelecao(
                    icone: Icons.schedule,
                    texto: _hora == null
                        ? 'Selecione o horário'
                        : '${Datas.doisDigitos(_hora!.hour)}:${Datas.doisDigitos(_hora!.minute)}',
                    vazio: _hora == null,
                    aoTocar: _escolherHora,
                  ),
                  const Rotulo('Pet'),
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.borda),
                    ),
                    child: const ListTile(
                      dense: true,
                      leading: AvatarPet('Thor', raio: 18),
                      title: Text('Thor', style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _solicitar,
                    icon: const Icon(Icons.event_available),
                    label: const Text('Solicitar agendamento'),
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
