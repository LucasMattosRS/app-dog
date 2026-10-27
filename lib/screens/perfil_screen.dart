import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'equipe/equipe_shell.dart';
import 'proprietario/proprietario_shell.dart';
import 'tutor/tutor_shell.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 16),
            Image.asset('assets/images/logo_sps.png', height: 90),
            const SizedBox(height: 28),
            const Text(
              'Um aplicativo para a operação inteira',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeEscuro,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Escolha seu perfil para continuar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.textoSuave),
            ),
            const SizedBox(height: 32),
            _CardPerfil(
              icone: Icons.pets,
              titulo: 'Tutor',
              descricao: 'Reserva serviços e acompanha seu pet.',
              aoTocar: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TutorShell()),
              ),
            ),
            _CardPerfil(
              icone: Icons.badge_outlined,
              titulo: 'Equipe',
              descricao: 'Executa a agenda e registra a rotina.',
              aoTocar: () => _abrir(context, const EquipeShell()),
            ),
            _CardPerfil(
              icone: Icons.insights,
              titulo: 'Proprietário',
              descricao: 'Controla a operação e acompanha o financeiro.',
              aoTocar: () => _abrir(context, const ProprietarioShell()),
            ),
          ],
        ),
      ),
    );
  }

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }
}

class _CardPerfil extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback aoTocar;

  const _CardPerfil({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: InkWell(
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icone, color: AppColors.verde, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.texto,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        descricao,
                        style: const TextStyle(color: AppColors.textoSuave),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textoSuave),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
