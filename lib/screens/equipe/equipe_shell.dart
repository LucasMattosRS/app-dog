import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../widgets/shell_abas.dart';
import '../mensagens/mensagens_screen.dart';
import 'agenda_equipe_screen.dart';
import 'banho_equipe_screen.dart';
import 'equipe_mais_screen.dart';
import 'taxi_equipe_screen.dart';

class EquipeShell extends StatelessWidget {
  const EquipeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShellAbas(
      telas: [
        AgendaEquipeScreen(),
        TaxiEquipeScreen(),
        BanhoEquipeScreen(),
        MensagensScreen(nomeResponsavel: Atividades.funcionarioLogado),
        EquipeMaisScreen(),
      ],
      destinos: [
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Agenda',
        ),
        NavigationDestination(
          icon: Icon(Icons.local_taxi_outlined),
          selectedIcon: Icon(Icons.local_taxi),
          label: 'Táxi Dog',
        ),
        NavigationDestination(
          icon: Icon(Icons.content_cut),
          label: 'Banho e tosa',
        ),
        NavigationDestination(
          icon: IconeMensagens(),
          label: 'Mensagens',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          label: 'Mais',
        ),
      ],
    );
  }
}
