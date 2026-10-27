import 'package:flutter/material.dart';
import 'screens/perfil_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/moldura_celular.dart';

void main() => runApp(const AppPet());

class AppPet extends StatelessWidget {
  const AppPet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPS Pet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      builder: (context, child) => MolduraCelular(child: child!),
      home: const PerfilScreen(),
    );
  }
}
