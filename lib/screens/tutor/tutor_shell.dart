import 'package:flutter/material.dart';
import '../../widgets/shell_abas.dart';
import 'adestramento_screen.dart';
import 'mais_screen.dart';
import 'meu_pet_screen.dart';
import 'reservas_screen.dart';

class TutorShell extends StatelessWidget {
  const TutorShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShellAbas(
      telas: [
        MeuPetScreen(),
        ReservasScreen(),
        AdestramentoScreen(),
        MaisScreen(),
      ],
      destinos: [
        NavigationDestination(
          icon: Icon(Icons.pets_outlined),
          selectedIcon: Icon(Icons.pets),
          label: 'Meu pet',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Reservas',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Adestramento',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          label: 'Mais',
        ),
      ],
    );
  }
}
