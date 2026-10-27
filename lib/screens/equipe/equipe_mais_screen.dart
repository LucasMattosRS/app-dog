import 'package:flutter/material.dart';
import '../../widgets/comum.dart';
import '../../widgets/item_info.dart';
import '../../widgets/tela_app.dart';
import 'cuidados_screen.dart';
import 'publicar_fotos_screen.dart';

class EquipeMaisScreen extends StatelessWidget {
  const EquipeMaisScreen({super.key});

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Mais',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ItemInfo(
            icone: Icons.favorite_border,
            titulo: 'Cuidados do pet',
            subtitulo: 'Checklist da rotina, observações e histórico',
            aoTocar: () => _abrir(
              context,
              const CuidadosScreen(pet: 'Thor', raca: 'Golden Retriever', servico: 'Hotel'),
            ),
          ),
          ItemInfo(
            icone: Icons.add_a_photo_outlined,
            titulo: 'Publicar fotos',
            subtitulo: 'Enviar fotos para o tutor correto, com a marca',
            aoTocar: () => _abrir(context, const PublicarFotosScreen()),
          ),
          const SizedBox(height: 8),
          ItemInfo(
            icone: Icons.logout,
            titulo: 'Trocar perfil',
            subtitulo: 'Voltar para a escolha de perfil',
            aoTocar: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
          const LogoRodape(),
        ],
      ),
    );
  }
}
