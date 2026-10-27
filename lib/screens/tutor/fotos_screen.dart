import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../theme/app_colors.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class FotosScreen extends StatefulWidget {
  const FotosScreen({super.key});

  @override
  State<FotosScreen> createState() => _FotosScreenState();
}

class _FotosScreenState extends State<FotosScreen> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Fotos',
      rodape: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => avisar(context, 'Fotos salvas no aparelho'),
              icon: const Icon(Icons.download),
              label: const Text('Baixar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => avisar(context, 'Abrindo compartilhamento...'),
              icon: const Icon(Icons.share),
              label: const Text('Compartilhar'),
            ),
          ),
        ],
      ),
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                const ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: AvatarPet('Thor', raio: 28),
                  title: Text(
                    'Thor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Golden Retriever'),
                  trailing: Icon(Icons.chevron_right),
                ),
                AbasSublinhadas(
                  opcoes: const ['Galeria', 'Vídeos'],
                  selecionada: _aba,
                  aoSelecionar: (i) => setState(() => _aba = i),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 18, color: AppColors.verdeEscuro),
                SizedBox(width: 6),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: 'Fotos disponíveis por ',
                      children: [
                        TextSpan(
                          text: 'até 48h',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_aba == 0)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.3,
              children: [
                for (final f in DadosDemo.fotosThor) FotoPet(f),
              ],
            )
          else
            const Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.videocam_off_outlined, size: 48, color: AppColors.textoSuave),
                  SizedBox(height: 8),
                  Text(
                    'Nenhum vídeo publicado hoje',
                    style: TextStyle(color: AppColors.textoSuave),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
