import 'package:flutter/material.dart';
import '../../widgets/comum.dart';
import '../../widgets/item_info.dart';
import '../../widgets/tela_app.dart';
import 'banho_tosa_screen.dart';
import 'cobrancas_screen.dart';
import 'fotos_screen.dart';
import 'taxi_dog_screen.dart';

class MaisScreen extends StatelessWidget {
  const MaisScreen({super.key});

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
            icone: Icons.photo_library_outlined,
            titulo: 'Fotos e rotina',
            subtitulo: 'Galeria do pet com a marca do estabelecimento',
            aoTocar: () => _abrir(context, const FotosScreen()),
          ),
          ItemInfo(
            icone: Icons.local_taxi_outlined,
            titulo: 'Táxi Dog',
            subtitulo: 'Solicitar busca, entrega ou ambas',
            aoTocar: () => _abrir(context, const TaxiDogScreen()),
          ),
          ItemInfo(
            icone: Icons.content_cut,
            titulo: 'Banho e tosa',
            subtitulo: 'Agendar banho, tosa ou serviço combinado',
            aoTocar: () => _abrir(context, const BanhoTosaScreen()),
          ),
          ItemInfo(
            icone: Icons.receipt_long_outlined,
            titulo: 'Cobranças',
            subtitulo: 'Vencimentos, histórico e pagamentos',
            aoTocar: () => _abrir(context, const CobrancasScreen()),
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
