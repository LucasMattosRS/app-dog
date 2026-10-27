import 'package:flutter/material.dart';
import '../../widgets/shell_abas.dart';
import 'concluidos_screen.dart';
import 'financeiro_screen.dart';
import 'painel_screen.dart';
import 'proprietario_mais_screen.dart';
import 'reservas_ocupacao_screen.dart';

class ProprietarioShell extends StatelessWidget {
  const ProprietarioShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShellAbas(
      telas: [
        PainelScreen(),
        ConcluidosScreen(),
        ReservasOcupacaoScreen(),
        FinanceiroScreen(),
        ProprietarioMaisScreen(),
      ],
      destinos: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Início',
        ),
        NavigationDestination(
          icon: Icon(Icons.task_alt),
          selectedIcon: Icon(Icons.task_alt),
          label: 'Concluídos',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_note_outlined),
          selectedIcon: Icon(Icons.event_note),
          label: 'Reservas',
        ),
        NavigationDestination(
          icon: Icon(Icons.payments_outlined),
          selectedIcon: Icon(Icons.payments),
          label: 'Financeiro',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          label: 'Mais',
        ),
      ],
    );
  }
}
